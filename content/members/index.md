---
title: "Members"
description: "Learn more about becoming a member of our community"
featured_image: ''
type: 'page'
featured_image: '/images/header1.png'
menu:
  main:
    weight: 100
---

{{/* /images/single.html */}}
{{ define "main" }}
<article class="members-only">
    <!-- Include Netlify Identity Widget in safe way for Hugo -->
    {{ $netlifyIdentity := resources.Get "js/netlify-identity-widget.js" | resources.ExecuteAsTemplate "js/netlify-identity-widget.js" . | minify | fingerprint }}
    <script src="https://identity.netlify.com/v1/netlify-identity-widget.js"></script>

    <!-- Login/Logout Button -->
    <div data-netlify-identity-button></div>

    <!-- Protected Content -->
    <div id="protected-content" style="display: none;">
        <h1>{{ .Title }}</h1>
        <div class="content">
            {{ .Content }}
        </div>
    </div>

    <!-- Public Content -->
    <div id="public-content">
        <h1>Please Log In</h1>
        <p>You must be logged in to view the protected content.</p>
    </div>

    <!-- Safe way to include JavaScript in Hugo -->
    {{ $js := `
        function checkUser() {
            const user = netlifyIdentity.currentUser();
            const protectedContent = document.getElementById('protected-content');
            const publicContent = document.getElementById('public-content');
            
            if (user) {
                protectedContent.style.display = 'block';
                publicContent.style.display = 'none';
            } else {
                protectedContent.style.display = 'none';
                publicContent.style.display = 'block';
            }
        }

        // Initial check
        checkUser();

        // Listen for login/logout events
        netlifyIdentity.on('login', () => {
            checkUser();
        });

        netlifyIdentity.on('logout', () => {
            checkUser();
        });
    ` }}
    {{ $js := resources.FromString "js/protected.js" $js | resources.Minify | resources.Fingerprint }}
    <script>{{ $js.Content | safeJS }}</script>
</article>
{{ end }}