require 'pop_ssl'

class FetchEmailInvitationRequestsJob
  ALLOWED_KROOGS = [{:user => 'aquarium', :kroog => 5}, {:user => 'chief', :kroog => 5}]

  def initialize(log)
    @log = log
  end

  def log
    @log
  end

  HANDLED_NONPROD_ENVS = ['staging', 'rc']
  
  def run
    username = 'iPhone@kroogi.com'
    password = 'alpine'
    FileUtils.makedirs(inbox_path)
    Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
    Net::POP3.start('secure.emailsrvr.com', 995, username, password) do |pop|
      pop.each_mail do |mail|
        msg  = TMail::Mail.parse(mail.top(100))
        msg_text = msg.subject + "\n" +  msg.body
        if RAILS_ENV == 'production'
          right_env = HANDLED_NONPROD_ENVS.none? {|env| msg_text["[#{env}]"]}
        else
          right_env = msg_text["[#{RAILS_ENV}]"]
        end
        process_mail(msg, msg_text, mail) if right_env
      end      
    end
  end

  def inbox_cleanup
    `rm -f #{inbox_path}/*`
    log.info "%s: cleaned up junk inbox messages from %s" % [self.class.name, inbox_path]
  end

  private

  def inbox_path
    "/mnt/krugi/kroogi/thisenv/shared/inbox"
  end
  
  def process_mail(msg, msg_text, mail)
    message_id = mail.unique_id
    if msg_text =~ /(kroog\d*-\d)/
      match = $1
      match =~ /kroog(\d*)-(\d)/
      user_id, relationshiptype_id = [$1, $2].map{|x| x.to_i}
      user = User.find_by_id(user_id)
      if user
        skipped = !maybe_invite_to(user, msg.from, message_id, relationshiptype_id)
      else
        log.warn("%s: skipped message %s: user %s not found" % [self.class.name, message_id, user_id])
        skipped = true
      end
    else
      log.warn("%s: skipped message %s: code not found in message" % [self.class.name, message_id])
      skipped = true
    end
    if skipped
      File.open("#{inbox_path}/#{message_id}", 'w') do |f|
        mail.pop do |chunk|
          f.write chunk
        end
      end
    end
    mail.delete
  end

  def allowed?(to_user, relationshiptype_id)
    filter = ALLOWED_KROOGS.find {|map| to_user.login == map[:user]}
    log.info "filter is %s, relationshiptype_id is %s" % [filter.inspect, relationshiptype_id]
    return false unless filter
    filter[:kroog] == relationshiptype_id
  end

  def maybe_invite_to(to_user, emails, message_id, relationshiptype_id)
    unless allowed?(to_user, relationshiptype_id)
      @log.warn("%s: couldn't invite %s from %s to kroog %s of %s: not allowed" % [self.class.name, emails.inspect,
                message_id, relationshiptype_id, to_user.login])
      return false
    end  
    skipped = true
    Thread.current['user'] = to_user
    invites_sent = Invite.send_invites({:to_invite => emails, :locale => 'ru', :circle_id => relationshiptype_id},
                                       to_user)
    if invites_sent.empty?
      @log.warn("%s: couldn't invite %s from %s to kroog %s of %s: already there?" % [self.class.name, emails.inspect,
                message_id, relationshiptype_id, to_user.login])
    else
      invites_sent.each do |invite|
        who = invite.user_email ? 'email %s' % invite.user_email : 'kroogi user %s' % invite.user_id.inspect
        @log.info("%s: #{who} was invited to kroog %s of user %s" % [self.class.name, invite.circle_id, to_user.login])        
      end
      skipped = false
    end
    !skipped
  end

end
