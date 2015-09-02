import stripe
from flask import Flask
from flask import request
from flask import json
 
app = Flask(__name__)
 
#1
@app.route('/pay', methods=['POST'])
def pay():
 
  #2
  # Set this to your Stripe secret key (use your test key!)
  stripe.api_key = "sk_test_ZACgZCsqSsWfehniBn69FH6l"
 
  #3
  # Parse the request as JSON
  json = request.get_json(force=True)
 
  # Get the credit card details
  token = json['stripeToken']
  amount = json['amount']
  description = json['description']
 
  # Create the charge on Stripe's servers - this will charge the user's card
  try:
    #4
    charge = stripe.Charge.create(
				  amount=amount,
				  currency="usd",
				  card=token,
				  description=description
			          )
  except stripe.CardError, e:
    # The card has been declined
    pass
 
  #5
    return "Success!"
 
if __name__ == '__main__':
  # Set as 0.0.0.0 to be accessible outside your local machine
  app.run(debug=True, host= '0.0.0.0')