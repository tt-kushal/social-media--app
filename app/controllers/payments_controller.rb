class PaymentsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_profile_existence


    def create
        amount = 10 
        begin
            charge = Stripe::Charge.create(
                amount: amount,
                currency: 'usd',    
                source: params[:stripeToken],
                description: 'Payment for verified tag'
            )

            payment = Payment.create(user: current_user, amount: amount, stripe_id: charge.id)
    
        # Perform actions specific to buying a "verified" tag, e.g., update user's status
        # current_user.update(verified: true)

            render json: { message: 'Payment for verified tag successful', payment: payment, charge: charge }
        rescue Stripe::CardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
    end


    # def get_token
    #     Stripe::Token.create({
    #       card: {
    #         number: credit_card_number,
    #         exp_month: credit_card_exp_month,
    #         exp_year: credit_card_exp_year,
    #         cvc: credit_card_cvv,
    #       }
    #     })
    # end

    private

    def check_profile_existence
        return if current_user.profile.present?
    
        render json: { message: "Create a profile first" }, status: :unauthorized
    end

end
