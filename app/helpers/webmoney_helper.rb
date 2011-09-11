module WebmoneyHelper
  
  # Dont display the entire account
  def obfuscate_account(acc_num, display_size=4)
    # can has no zeros
    display_size = acc_num.size if acc_num.size < display_size
    left = acc_num.size - display_size
    acc_num.to_s[0..(display_size-1)] + ('*' * left)
  end
end
