class UserMessageSerializer < MessageSerializer
  attributes :is_private

  def is_private
    object.private?
  end
end