#--
# Copyright (c) 2010-2013 Michael Berkovich, Geni Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

class Tr8n::LanguageForumMessageNotification < Tr8n::Notification

  def self.distribute(message)
    # find translators for all other translations of the key in this language
    messages = Tr8n::LanguageForumMessage.find(:all, :conditions => ["language_forum_topic_id = ?", 
                                                 message.language_forum_topic.id])

    translators = []
    messages.each do |m|
      translators << m.translator
    end

    translators += followers(message.translator)

    # remove the current translator
    translators = translators.uniq - [message.translator]

    translators.each do |t|
      create(:translator => t, :object => message, :actor => message.translator, :action => "replied_to_forum_topic")
    end
  end

  def title
    tr("[link: {user}] replied to a forum topic you are following.", nil, 
      :user => actor, :link => [actor.url]
    )
  end


end
