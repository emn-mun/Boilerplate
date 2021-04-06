### An iOS app using MVP and RxSwift, that contains two screens as described below:

* Login screen
	* text field for email (validate for existence of "@", change border colors to black/red/blue)
	* text field for password (validate for non-empty, change border colors to black/red/blue)
	* button for login
		* disable on validation failure
		* title
			* "Login" (default)
			* "Cancel" (while request is running)
			* "Try again" (after request has failed)
	* activity indicator (when request is running)
	* error label
		* empty (default)
		* text (localizedMessage from backend, when request has failed)

* Success screen
	* label "hello."
	* navigation bar with back button

* Networking
	* https://p0jtvgfrj3.execute-api.eu-central-1.amazonaws.com/test/authenticate
	* POST `{ "email": "...", "password": "..." }` (fill in values)
	* expect (200, 401 or 500 will be randomly returned by the api, so you will see all the cases in the app)
		* 200: `{ "token": "uuidv4", "message": "Sample greetings message" }`
		* 401: `{ "message": "Sample authentication error message" }`
		* 4xx/5xx (if something really goes wrong)
