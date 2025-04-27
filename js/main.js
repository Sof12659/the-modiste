// Main JavaScript for Sew Real website

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeNavigation();
    initializeModal();
    addDecorations();
    
    // Add sparkle effects on hover for buttons
    addSparkleEffects();
});

// Navigation functionality
function initializeNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    
    navItems.forEach(item => {
        item.addEventListener('click', function(e) {
            // Handle login button separately
            if (this.classList.contains('login-button')) {
                e.preventDefault();
                openModal('login-modal');
                return;
            }
            
            // For other nav items, just add active class
            navItems.forEach(navItem => navItem.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

// Modal functionality
function initializeModal() {
    // Get all modals
    const modals = document.querySelectorAll('.modal');
    
    // Get all close buttons
    const closeButtons = document.querySelectorAll('.close-button');
    
    // Get login button
    const loginButton = document.querySelector('.login-button');
    if (loginButton) {
        loginButton.addEventListener('click', function(e) {
            e.preventDefault();
            openModal('login-modal');
        });
    }
    
    // Get signup link
    const signupLink = document.getElementById('signup-link');
    if (signupLink) {
        signupLink.addEventListener('click', function(e) {
            e.preventDefault();
            // In a real implementation, this would open a signup modal
            alert('Sign up functionality would open here!');
        });
    }
    
    // Close modal when clicking close button
    closeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const modal = this.closest('.modal');
            closeModal(modal);
        });
    });
    
    // Close modal when clicking outside content
    modals.forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal(this);
            }
        });
    });
}

function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'flex';
        
        // Add entrance animation
        const modalContent = modal.querySelector('.modal-content');
        if (modalContent) {
            modalContent.style.animation = 'float 0.5s ease-out';
        }
    }
}

function closeModal(modal) {
    modal.style.display = 'none';
}

// Add decorative elements
function addDecorations() {
    // Add floating bubbles to hero section
    const heroSection = document.querySelector('.hero-section');
    if (heroSection) {
        for (let i = 0; i < 5; i++) {
            const bubble = document.createElement('div');
            bubble.className = 'floating-bubble';
            bubble.style.width = `${Math.random() * 100 + 50}px`;
            bubble.style.height = bubble.style.width;
            bubble.style.top = `${Math.random() * 100}%`;
            bubble.style.left = `${Math.random() * 100}%`;
            bubble.style.animationDelay = `${Math.random() * 5}s`;
            heroSection.appendChild(bubble);
        }
    }
    
    // Add sparkles to CTA section
    const ctaSection = document.querySelector('.cta-section');
    if (ctaSection) {
        for (let i = 0; i < 10; i++) {
            const sparkle = document.createElement('div');
            sparkle.className = 'sparkle';
            sparkle.style.top = `${Math.random() * 100}%`;
            sparkle.style.left = `${Math.random() * 100}%`;
            sparkle.style.animationDelay = `${Math.random() * 2}s`;
            ctaSection.appendChild(sparkle);
        }
    }
}

// Add sparkle effects on hover for buttons
function addSparkleEffects() {
    const buttons = document.querySelectorAll('.button');
    
    buttons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            // Create sparkles around the button
            for (let i = 0; i < 5; i++) {
                const sparkle = document.createElement('div');
                sparkle.className = 'sparkle';
                
                // Position randomly around the button
                const rect = this.getBoundingClientRect();
                const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                
                sparkle.style.top = `${rect.top + scrollTop + Math.random() * rect.height}px`;
                sparkle.style.left = `${rect.left + Math.random() * rect.width}px`;
                sparkle.style.animationDelay = `${Math.random() * 0.5}s`;
                
                document.body.appendChild(sparkle);
                
                // Remove sparkle after animation completes
                setTimeout(() => {
                    sparkle.remove();
                }, 2000);
            }
        });
    });
}

// Form validation
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.querySelector('.login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            // Simple validation
            if (!email || !password) {
                alert('Please fill in all fields');
                return;
            }
            
            // In a real implementation, this would send a login request to the server
            alert('Login functionality would happen here!');
            
            // Close the modal
            const modal = this.closest('.modal');
            closeModal(modal);
        });
    }
});
