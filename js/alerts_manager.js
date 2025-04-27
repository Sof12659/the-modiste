// Alerts Functionality - Handles image search and alert creation

class AlertsManager {
  constructor() {
    this.searchResults = [];
    this.designImage = null;
    this.init();
  }

  init() {
    // Set up event listeners
    document.addEventListener('DOMContentLoaded', () => {
      // Find matches button
      const findMatchesBtn = document.getElementById('find-matches');
      if (findMatchesBtn) {
        findMatchesBtn.addEventListener('click', () => this.findMatches());
      }
      
      // Set alert link
      const setAlertLink = document.getElementById('set-alert-link');
      if (setAlertLink) {
        setAlertLink.addEventListener('click', (e) => {
          e.preventDefault();
          this.openAlertModal();
        });
      }
      
      // Create alert button
      const createAlertBtn = document.getElementById('create-alert');
      if (createAlertBtn) {
        createAlertBtn.addEventListener('click', () => this.createAlert());
      }
      
      // Close modal buttons
      const closeButtons = document.querySelectorAll('.close-button');
      closeButtons.forEach(button => {
        button.addEventListener('click', () => {
          const modal = button.closest('.modal');
          if (modal) {
            modal.style.display = 'none';
          }
        });
      });
    });
  }

  // Capture the current design as an image
  captureDesign() {
    const avatarContainer = document.querySelector('.avatar-container');
    if (!avatarContainer) return null;
    
    // In a real implementation, this would use html2canvas or similar
    // For this demo, we'll simulate by using the cheetah pattern as a placeholder
    this.designImage = 'images/patterns/cheetah.png';
    return this.designImage;
  }

  // Find matching images
  findMatches() {
    // Capture the current design
    const designImage = this.captureDesign();
    if (!designImage) return;
    
    // In a real implementation, this would search Google Images
    // For this demo, we'll simulate with random results
    const hasResults = Math.random() > 0.3; // 70% chance of finding results
    
    // Show search results area
    const searchResultsArea = document.getElementById('search-results');
    if (searchResultsArea) {
      searchResultsArea.style.display = 'block';
    }
    
    if (hasResults) {
      // Show results
      this.displaySearchResults();
    } else {
      // Show no results message
      this.displayNoResults();
    }
    
    // Scroll to results
    searchResultsArea.scrollIntoView({ behavior: 'smooth' });
  }

  // Display search results
  displaySearchResults() {
    const resultsGrid = document.getElementById('results-grid');
    const noResults = document.getElementById('no-results');
    
    if (resultsGrid && noResults) {
      resultsGrid.style.display = 'grid';
      noResults.style.display = 'none';
      
      // Clear previous results
      resultsGrid.innerHTML = '';
      
      // Generate some dummy results
      const dummyResults = [
        { image: 'images/patterns/cheetah.png', title: 'Cheetah Print Dress', price: '$49.99' },
        { image: 'images/patterns/cheetah.png', title: 'Animal Print Top', price: '$29.99' },
        { image: 'images/patterns/cheetah.png', title: 'Leopard Pattern Skirt', price: '$39.99' },
        { image: 'images/patterns/cheetah.png', title: 'Wild Cat Blouse', price: '$34.99' }
      ];
      
      // Add results to grid
      dummyResults.forEach(result => {
        const resultItem = document.createElement('div');
        resultItem.className = 'result-item';
        
        const resultImage = document.createElement('img');
        resultImage.src = result.image;
        resultImage.alt = result.title;
        
        const resultInfo = document.createElement('div');
        resultInfo.className = 'result-info';
        
        const resultTitle = document.createElement('h3');
        resultTitle.textContent = result.title;
        
        const resultPrice = document.createElement('p');
        resultPrice.textContent = result.price;
        
        resultInfo.appendChild(resultTitle);
        resultInfo.appendChild(resultPrice);
        
        resultItem.appendChild(resultImage);
        resultItem.appendChild(resultInfo);
        
        resultsGrid.appendChild(resultItem);
      });
    }
  }

  // Display no results message
  displayNoResults() {
    const resultsGrid = document.getElementById('results-grid');
    const noResults = document.getElementById('no-results');
    
    if (resultsGrid && noResults) {
      resultsGrid.style.display = 'none';
      noResults.style.display = 'block';
    }
  }

  // Open alert modal
  openAlertModal() {
    const alertModal = document.getElementById('alert-modal');
    const alertPreview = document.getElementById('alert-preview');
    
    if (alertModal && alertPreview && this.designImage) {
      // Set preview image
      alertPreview.src = this.designImage;
      
      // Show modal
      alertModal.style.display = 'block';
    }
  }

  // Create alert
  createAlert() {
    // In a real implementation, this would save the alert to a database
    // For this demo, we'll just show a success message
    alert('Alert created successfully! You will be notified when matching items are found.');
    
    // Close modal
    const alertModal = document.getElementById('alert-modal');
    if (alertModal) {
      alertModal.style.display = 'none';
    }
    
    // Redirect to alerts page
    window.location.href = 'alerts.html';
  }
}

// Initialize alerts manager
document.addEventListener('DOMContentLoaded', () => {
  const alertsManager = new AlertsManager();
});
