// Gallery Page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // View toggle functionality
    const viewButtons = document.querySelectorAll('.view-controls .view-btn');
    const designsGrid = document.querySelector('.designs-grid');
    const designsList = document.querySelector('.designs-list');
    
    viewButtons.forEach(button => {
        button.addEventListener('click', function() {
            viewButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            const view = this.getAttribute('data-view');
            if (view === 'grid') {
                designsGrid.style.display = 'grid';
                designsList.style.display = 'none';
            } else if (view === 'list') {
                designsGrid.style.display = 'none';
                designsList.style.display = 'flex';
            }
        });
    });
    
    // Filter tags functionality
    const filterTags = document.querySelectorAll('.filter-tag');
    const designCards = document.querySelectorAll('.design-card');
    
    filterTags.forEach(tag => {
        tag.addEventListener('click', function() {
            filterTags.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            const filter = this.getAttribute('data-filter');
            
            if (filter === 'all') {
                designCards.forEach(card => {
                    card.style.display = 'block';
                });
            } else if (filter === 'recent') {
                // In a real implementation, this would filter based on date
                // For now, just show the first 3 cards as an example
                designCards.forEach((card, index) => {
                    if (index < 3) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            } else if (filter === 'with-alerts') {
                designCards.forEach(card => {
                    if (card.querySelector('.alert-badge')) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            } else if (filter === 'with-matches') {
                designCards.forEach(card => {
                    if (card.querySelector('.match-badge')) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            } else if (filter === 'favorites') {
                designCards.forEach(card => {
                    if (card.querySelector('.favorite-btn.active')) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }
        });
    });
    
    // Sort functionality
    const sortSelect = document.getElementById('sort-select');
    
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            const sortValue = this.value;
            const designsContainer = document.querySelector('.designs-grid');
            const designs = Array.from(designsContainer.querySelectorAll('.design-card:not(.new-design)'));
            
            designs.sort((a, b) => {
                const aTitle = a.querySelector('h3').textContent;
                const bTitle = b.querySelector('h3').textContent;
                const aDate = a.querySelector('.design-date').textContent;
                const bDate = b.querySelector('.design-date').textContent;
                
                if (sortValue === 'newest') {
                    return bDate.localeCompare(aDate);
                } else if (sortValue === 'oldest') {
                    return aDate.localeCompare(bDate);
                } else if (sortValue === 'name-asc') {
                    return aTitle.localeCompare(bTitle);
                } else if (sortValue === 'name-desc') {
                    return bTitle.localeCompare(aTitle);
                }
            });
            
            // Remove all designs from container
            designs.forEach(design => design.remove());
            
            // Add sorted designs back to container
            const newDesignCard = designsContainer.querySelector('.new-design');
            designs.forEach(design => {
                designsContainer.insertBefore(design, newDesignCard);
            });
        });
    }
    
    // Search functionality
    const searchInput = document.getElementById('gallery-search');
    
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchValue = this.value.toLowerCase();
            
            designCards.forEach(card => {
                const title = card.querySelector('h3').textContent.toLowerCase();
                
                if (card.classList.contains('new-design')) {
                    card.style.display = 'block';
                } else if (title.includes(searchValue)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }
    
    // Design card actions
    const actionButtons = document.querySelectorAll('.action-btn');
    
    actionButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation(); // Prevent card click
            
            const action = this.getAttribute('title');
            const designCard = this.closest('.design-card');
            const designName = designCard.querySelector('h3').textContent;
            
            switch (action) {
                case 'Edit Design':
                    window.location.href = 'designer.html';
                    break;
                case 'Search for Matches':
                    window.location.href = 'search-results.html';
                    break;
                case 'Set Alert':
                    window.location.href = 'alerts.html';
                    break;
                case 'Add to Favorites':
                    this.innerHTML = '<i class="fas fa-heart"></i>';
                    this.classList.add('active');
                    this.setAttribute('title', 'Remove from Favorites');
                    break;
                case 'Remove from Favorites':
                    this.innerHTML = '<i class="far fa-heart"></i>';
                    this.classList.remove('active');
                    this.setAttribute('title', 'Add to Favorites');
                    break;
            }
        });
    });
    
    // Design card click to open detail modal
    const designCards = document.querySelectorAll('.design-card:not(.new-design)');
    const designDetailModal = document.getElementById('design-detail-modal');
    const closeModalBtn = document.querySelector('.close-modal');
    
    designCards.forEach(card => {
        card.addEventListener('click', function() {
            if (designDetailModal) {
                designDetailModal.style.display = 'block';
                document.body.style.overflow = 'hidden';
                
                // In a real implementation, this would load the specific design details
                // For now, we'll just update the title
                const designName = this.querySelector('h3').textContent;
                designDetailModal.querySelector('h2').textContent = designName;
                
                // Update the main preview image
                const designImage = this.querySelector('img').src;
                designDetailModal.querySelector('.main-preview').src = designImage;
            }
        });
    });
    
    if (closeModalBtn) {
        closeModalBtn.addEventListener('click', function() {
            designDetailModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        });
    }
    
    // Close modal when clicking outside content
    if (designDetailModal) {
        designDetailModal.addEventListener('click', function(e) {
            if (e.target === this) {
                designDetailModal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    }
    
    // Design view buttons in modal
    const designViewButtons = document.querySelectorAll('.design-views .view-btn');
    
    designViewButtons.forEach(button => {
        button.addEventListener('click', function() {
            designViewButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // In a real implementation, this would switch the design view
            const view = this.getAttribute('data-view');
            console.log(`Switched to ${view} view`);
        });
    });
    
    // New design card functionality
    const newDesignCard = document.querySelector('.new-design');
    
    if (newDesignCard) {
        newDesignCard.addEventListener('click', function() {
            window.location.href = 'designer.html';
        });
    }
    
    // Pagination functionality
    const paginationBtns = document.querySelectorAll('.pagination-btn');
    
    paginationBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            if (!this.classList.contains('active') && !this.classList.contains('next')) {
                paginationBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                // In a real implementation, this would load the next page of designs
                console.log(`Switched to page ${this.textContent}`);
            }
        });
    });
});
