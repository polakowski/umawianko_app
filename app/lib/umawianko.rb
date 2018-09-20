module Umawianko
  class UserNotSignedIn < StandardError; end
  class OAuthError < StandardError; end
  class RuntimeError < StandardError; end
  class NotImplementedError < StandardError; end
  class InvalidSlackInteraction < StandardError; end
  class SlackInteractionUserNotFound < StandardError; end
end
