Feature: WebMoney Donation
	In order to receive money a user should be able to attach their WebMoney account so that they can receive donations.

	Scenario: Requesting Payment Connection
		Given a user is logged in as "rickybobby"
		And I follow "Money"
		Then I should see "Waiting for admins to enable monetary options for this account."
		When I follow "Request to become an early adopter"
		And I am redirected
		Then I should see "You have requested to become an early adopter."
		
		Given an administrator authorizes payments for "rickybobby"
		When I follow "Money"
		Then I should see "You do not have any WebMoney purses."
		And I should see "You do not have a PayPal account configured."
		
		Given I follow "Attach your WebMoney purses"
		Then I should see "Connect your existing WebMoney account."
		When I fill in "donation[sender_wmid]" with "01234567890"
		And I fill in "password[]" with "testing"
		And I press "Connect"
		Then I should see "invalid"
		## Pick up here after mocking out WM responses
