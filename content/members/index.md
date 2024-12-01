---
title: "Membership"
description: "Learn more about becoming a member of our community"
featured_image: ''
type: 'page'
featured_image: '/images/header1.png'
menu:
  main:
    weight: 1
---
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Members Only Page</title>
    <!-- Include Netlify Identity Widget -->
    <script src="https://identity.netlify.com/v1/netlify-identity-widget.js"></script>
</head>

    <!-- Login/Logout Button -->
    <div data-netlify-identity-button></div>

    <!-- Protected Content -->
    <div id="protected-content" style="display: none;">
        <h1>Welcome to the Members Area</h1>
        <p>This content is only visible to logged-in members.</p>
        <!-- Add your protected content here -->
    </div>

    <!-- Public Content -->
    <div id="public-content">
        <h1>Please Log In</h1>
        <p>You must be logged in to view the protected content.</p>
    </div>

    <script>
        // Check if user is logged in
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
    </script>
