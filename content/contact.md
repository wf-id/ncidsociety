---
title: "Contact"
description: "Reach out!"
featured_image: ''
type: 'page'
omit_header_text: true
featured_image: ''
menu:
  main:
    weight: 99
---

## Other questions?

Please feel free to contact us using the below form:

{{< form-contact action="https://formspree.io/f/xgebgard" >}}

{{ $html := '<script src="https://js.stripe.com/v3/"></script>'}}
{{ $html | safeHTML }}

{{ $html :='
<div
      style="
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      "
    >
      <h1 style="text-align: center">💸💸 Serverless Payment example 💸💸</h1>
      <button id="checkout-button">Trigger payment</button>
      <script type="text/javascript">
        // Create an instance of the Stripe object with your publishable API key
        var stripe = Stripe(
          "pk_live_51Q7zKCL65pWiEB0M0ixTxTbaIKI18Itol677cPYxJSWdsVryIzpsTFWnZIDzFSu1tbnsOZp4laoQdP9Xn8GOhgT400a1EI0rVz"
        );
        var checkoutButton = document.getElementById("checkout-button");

        checkoutButton.addEventListener("click", function () {
          // Create a new Checkout Session using the server-side endpoint you
          // created in step 3.
          fetch("/api/stripe", {
            method: "POST",
          })
            .then(function (response) {
              return response.json();
            })
            .then(function (session) {
              return stripe.redirectToCheckout({ sessionId: session.id });
            })
            .then(function (result) {
              // If `redirectToCheckout` fails due to a browser or network
              // error, you should display the localized error message to your
              // customer using `error.message`.
              if (result.error) {
                alert(result.error.message);
              }
            })
            .catch(function (error) {
              console.error("Error:", error);
            });
        });
      </script>
    </div>
'}}
{{ $html | safeHTML }}