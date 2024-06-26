# typed: false
class Backoffice::MessageController::MessageService
  extend T::Sig

  def initialize(user)
    @user = user
  end

  sig {
    params(from_name: T.untyped, from_email: T.untyped, to_name: T.untyped, to_email: T.untyped, message: T.untyped)
      .returns(OpenStruct)
  }

  def send_message(from_name, from_email, to_name, to_email, message)
    @errors = T.let([], T.nilable(T::Array[T.untyped]))
    @message_sent = T.let(OpenStruct.new(success: false, message: ""), T.nilable(OpenStruct))

    if @errors.nil?
      raise "Error to initialize @errors"
    end

    if @message_sent.nil?
      raise "Error to initialize @message_sent"
    end

    if message.blank?
      @errors.push("#{I18n.t("layout.text.backoffice.management.users.send_email.message")}
                    #{I18n.t("errors.messages.blank")}")
    end
    if !message.blank? && message.length < 2
      @errors.push(I18n.t "errors.messages.message_min_length", min_length: 2)
    end
    if from_email == to_email
      @errors.push(I18n.t "errors.messages.recipient.same_as_user")
    end
    if to_email.blank?
      @errors.push("#{I18n.t("layout.text.backoffice.management.users.send_email.recipient")}
                    #{I18n.t("errors.messages.blank")}")
    end
    if @errors.any?
      @message_sent[:message] = @errors.join("\n")
      return @message_sent
    end

    begin
      simulate_error?

      AdminMailer.send_message_to(from_name, from_email, to_name, to_email, message).deliver_now

      @message_sent[:success] = true
      @message_sent[:message] = I18n.t "layout.message.text.success_to_send"
    rescue Exception => e
      Rails.logger.error "Error to send message: #{e}"
      @message_sent[:message] = I18n.t "layout.message.text.error_to_send"
    ensure
      return @message_sent
    end
  end

  private

  sig { void }

  def simulate_error?
    raise_error = [1..10].sample % 2 == 0
    Rails.logger.debug "Should raise an error? #{raise_error ? "yes" : "no"}"
    if raise_error
      raise "Email could not be sent, check the logs for more details!"
    end
  end
end
