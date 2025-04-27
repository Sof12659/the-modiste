// Search Results Page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Price slider functionality
    const priceSlider = document.getElementById('price-slider');
    const priceValue = document.getElementById('price-value');
    
    if (priceSlider && priceValue) {
        priceSlider.addEventListener('input', function() {
            priceValue.textContent = this.value;
        });
    }
    
    // Filter panel functionality
    const applyFiltersBtn = document.getElementById('apply-filters');
    const resetFiltersBtn = document.getElementById('reset-filters');
    
    if (applyFiltersBtn) {
        applyFiltersBtn.addEventListener('click', function() {
            // In a real implementation, this would apply filters to the results
            alert('Filters applied!');
            // Simulate loading new results
            simulateLoading();
        });
    }
    
    if (resetFiltersBtn) {
        resetFiltersBtn.addEventListener('click', function() {
            // Reset all filter inputs
            document.querySelectorAll('.filter-panel input[type="checkbox"]').forEach(checkbox => {
                checkbox.checked = false;
            });
            
            document.querySelectorAll('.filter-panel input[type="radio"]').forEach(radio => {
                if (radio.parentElement.textContent.trim() === 'Any') {
                    radio.checked = true;
                } else {
                    radio.checked = false;
                }
            });
            
            if (priceSlider) {
                priceSlider.value = 250;
                priceValue.textContent = '250';
            }
            
            alert('Filters reset!');
        });
    }
    
    // Sort functionality
    const sortSelect = document.getElementById('sort-select');
    
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            // In a real implementation, this would sort the results
            console.log(`Sorting by: ${this.value}`);
            // Simulate loading new results
            simulateLoading();
        });
    }
    
    // Quick view functionality
    const quickViewBtns = document.querySelectorAll('.quick-view-btn');
    const quickViewModal = document.getElementById('quick-view-modal');
    const closeModalBtn = document.querySelector('.close-modal');
    
    quickViewBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            if (quickViewModal) {
                quickViewModal.style.display = 'block';
                document.body.style.overflow = 'hidden';
            }
        });
    });
    
    if (closeModalBtn) {
        closeModalBtn.addEventListener('click', function() {
            quickViewModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        });
    }
    
    // Close modal when clicking outside content
    if (quickViewModal) {
        quickViewModal.addEventListener('click', function(e) {
            if (e.target === this) {
                quickViewModal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    }
    
    // Thumbnail gallery functionality
    const thumbnails = document.querySelectorAll('.thumbnail-gallery img');
    const mainImage = document.querySelector('.main-image');
    
    thumbnails.forEach(thumbnail => {
        thumbnail.addEventListener('click', function() {
            // Remove active class from all thumbnails
            thumbnails.forEach(t => t.classList.remove('active'));
            
            // Add active class to clicked thumbnail
            this.classList.add('active');
            
            // Update main image
            if (mainImage) {
                mainImage.src = this.src;
            }
        });
    });
    
    // Favorite button functionality
    const favoriteBtns = document.querySelectorAll('.favorite-btn');
    
    favoriteBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const icon = this.querySelector('i');
            
            if (icon.classList.contains('far')) {
                icon.classList.remove('far');
                icon.classList.add('fas');
                this.setAttribute('title', 'Remove from favorites');
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
                this.setAttribute('title', 'Add to favorites');
            }
        });
    });
    
    // Pagination functionality
    const paginationBtns = document.querySelectorAll('.pagination-btn');
    
    paginationBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            if (!this.classList.contains('active') && !this.classList.contains('next')) {
                paginationBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                // Simulate loading new page
                simulateLoading();
            }
        });
    });
    
    // No results actions
    const setAlertBtn = document.getElementById('set-alert-btn');
    const findSeamstressBtn = document.getElementById('find-seamstress-btn');
    const modifyDesignBtn = document.getElementById('modify-design-btn');
    
    if (setAlertBtn) {
        setAlertBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = 'alerts.html';
        });
    }
    
    if (findSeamstressBtn) {
        findSeamstressBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = 'seamstress.html';
        });
    }
    
    if (modifyDesignBtn) {
        modifyDesignBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = 'designer.html';
        });
    }
    
    // Toggle no results section (for demo purposes)
    const modifySearchBtn = document.getElementById('modify-search');
    const resultsContent = document.querySelector('.results-content');
    const noResultsSection = document.querySelector('.no-results-section');
    
    if (modifySearchBtn && resultsContent && noResultsSection) {
        modifySearchBtn.addEventListener('click', function() {
            if (resultsContent.style.display !== 'none') {
                resultsContent.style.display = 'none';
                noResultsSection.style.display = 'block';
            } else {
                resultsContent.style.display = 'flex';
                noResultsSection.style.display = 'none';
            }
        });
    }
    
    // Helper function to simulate loading
    function simulateLoading() {
        const productGrid = document.querySelector('.product-grid');
        
        if (productGrid) {
            productGrid.style.opacity = '0.5';
            
            setTimeout(() => {
                productGrid.style.opacity = '1';
            }, 800);
        }
    }
});
