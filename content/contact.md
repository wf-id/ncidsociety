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




<!--Mandatory  script pour STRIPE -->
<script src="https://js.stripe.com/v3/"></script>

<style>
  /* Pour le shop */
.product input {
  border: 1px solid teal;
  border-radius: 0.25rem;
  font-size: 1.125rem;
  line-height: 1.25rem;
  padding: 0.2rem;
}
.product button {
  background: teal;
  border: none;
  border-radius: 0.25rem;
  color: white;
  font-size: 1.1rem;
  font-weight: 800;
  line-height: 1.1rem;
  padding: 0.25rem;
  width: 110px;
  height: 30px;
  margin-bottom: 40px;
}
.product h2 {
  font-size: 1.25rem;
}
.product .price {
  font-weight: 800;
}
.product .description {
  font-style: italic;
}
</style>

<!-- Titre du SHOP -->
<section class="section bg-gray" id="shop">
   <!-- Shop managed directly by Hugo -->
   <div class="container">
      <div class="row align-items-end">
         <!-- data articles MANDATORY put in /functions/data : needed for create-checkout.js used by Netlify function -->
         {{- $count := 0 }}
         {{- $dataJSON := getJSON "/functions/data/products.json" }}
         {{- range $dataJSON }}
         {{- $count = add $count 1 }}
            <div class="col-lg-4 col-md-6 col-sm-12 ">
               <div class="product">
                  <!--  Images in ASSETS
                        Manage switch 2 images by prodcut / with simple mouse over
                        and adapt same height to avoid flicking -->
                  {{- $img_original := resources.Get .image  -}}
                  {{- $img := $img_original.Resize "400x400" -}}
                  {{- $img_hover := "" }}
                  {{- if .image_hover }}
                     {{- $img_hover_original := resources.Get .image_hover  -}}
                     {{- $img_hover = $img_hover_original.Resize "400x400" -}}
                  {{- end }}
                  {{- $lazy := "" -}}
                  <img
                     {{- if site.Params.global.lazyload.enable }}
                        {{- $lazy = site.Params.global.lazyload.label -}}
                        {{- $placeholder := $img_original.Resize "3x q20" }}
                        src="data:image/jpeg;base64,{{ $placeholder.Content | base64Encode }}"
                        data-src="{{- $img.RelPermalink -}}"
                     {{- else }}
                        src="{{- $img.RelPermalink -}}"
                     {{- end }}
                     class = "img-fluid shadow rounded {{ $lazy -}}"
                     alt = "{{ .name }}"
                     title = "{{- .description -}}"
                     width = "{{- $img.Width -}}" height = "{{- $img.Height -}}"
                     {{- if .image_hover }}
                        onmouseover="this.src='{{ $img_hover.RelPermalink }}'"
                        onmouseout="this.src='{{ $img.RelPermalink }}'"
                     {{- end }}
                  >
                  <!-- Use this code if you want to use images from STATIC folder
                  <img src="{{ .image | relURL }}"
                     {{- if .image_hover }}
                        onmouseover="this.src='{{ .image_hover }}'"
                        onmouseout="this.src='{{ .image }}'"
                     {{- end }}
                     alt = "{{ .name }}"
                     />
                  -->

                  <h2>{{ .name }}</h2>
                  <p class="description">{{ .description}}</p>
                  <p class="price">{{ i18n "prix-shop" }} : {{ lang.NumFmt 2 (div (float .amount) 100) }} {{ .currency }}</p>
                  <form action="" method="POST" id="hugoform{{ $count }}">
                     <label for="quantity">{{ i18n "quantity-shop" }} :</label>
                     <input type="number" id="quantity" name="quantity" value="1" min="1" max="10" />
                     <input type="hidden" name="sku" value="{{ .sku }}" />
                     <!-- For multilanguage sites -->
                     <input type="hidden" name="formlang" value="{{ $.Page.Lang }}" />
                     <!--  We manage images on shop & on Stripe checkout
                           with only ONE image on Hugo
                           Stripe Checkout need an ABSOLUTE URL reachable from Internet
                           And we have RELATIVE path in our products.json -->
                     <!-- Needed if Images are managed from STATIC -->
                     {{- $stripeImgPath := (strings.TrimRight "/" site.BaseURL) }}
                     <input type="hidden" name="stripeImgPath" value="{{ $stripeImgPath }}" />
                     <!-- Needed if Images are managed from ASSET -->
                     <input type="hidden" name="stripeImg" value="{{ $img.Permalink }}" />
                     <br>
                     <button type="submit">{{ i18n "buy-shop" }}</button>
                  </form>
               </div>
            </div>

         {{- end }}
      </div>

   </div>

   <!-- Script for this shop going to Stripe -->
   <script type="module" >
      // Manage submit button goinf to Stripe
      import { handleFormSubmission } from '/js/stripe-purchase.js';
      {{- range seq $count }}
         // Manage eventlistener for each button/form
         document.getElementById('hugoform{{ $count}}').addEventListener('submit', handleFormSubmission);
         {{- $count = sub $count 1 }}
      {{- end }}
   </script>

</section>
{{ "<!-- End shop section -->" | safeHTML }}
