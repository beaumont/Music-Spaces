######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Hui (zhengzhengzheng@gmail.com) - port to Ruby
#   Mark Pilgrim - first port to Python
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

require 'UniversalDetector'
require 'CharSetProber'
require 'CodingStateMachine'
require 'ESCSM'

module  UniversalDetector
    class EscCharSetProber < CharSetProber
        def initialize
            super
            @_mCodingSM = [ \
                CodingStateMachine(HZSMModel),
                CodingStateMachine(ISO2022CNSMModel),
                CodingStateMachine(ISO2022JPSMModel),
                CodingStateMachine(ISO2022KRSMModel)
                ]
            reset()
        end

        def reset
            super
            for codingSM in @_mCodingSM
                unless codingSM then continue end
                codingSM.active = true
                codingSM.reset()
            end
            @_mActiveSM = @_mCodingSM.length
            @_mDetectedCharset = nil
        end

        def get_charset_name
            return @_mDetectedCharset
        end

        def get_confidence
            if @_mDetectedCharset
                return 0.99
            else
                return 0.00
            end
        end

        def feed(aBuf)
            for c in aBuf
                for codingSM in @_mCodingSM
                    unless codingSM then continue end
                    unless codingSM.active then continue end
                    codingState = codingSM.next_state(c)
                    if codingState == :Error
                        codingSM.active = false
                        @_mActiveSM -= 1
                        if @_mActiveSM <= 0
                            @_mState = :NotMe
                            return get_state()
                        end
                    elsif codingState == :ItsMe
                        @_mState = :FoundIt
                        @_mDetectedCharset = codingSM.get_coding_state_machine()
                        return get_state()
                    end
                end
            end

            return get_state()
        end
    end
end
