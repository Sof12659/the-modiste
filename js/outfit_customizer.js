// Outfit Customizer - Handles color and pattern customization for clothing items

class OutfitCustomizer {
  constructor() {
    this.currentItem = null;
    this.currentTab = 'color'; // 'color' or 'pattern'
    this.availablePatterns = [
      { id: 'cheetah', name: 'Cheetah Print', image: 'images/patterns/cheetah.png' },
      { id: 'jeans', name: 'Jeans Material', image: 'images/patterns/jeans-material.png' }
      // More patterns can be added here
    ];
    this.init();
  }

  init() {
    // Create customization popup
    this.createCustomizationPopup();
    
    // Set up event listeners for clothing items
    this.setupClothingItemListeners();
  }

  createCustomizationPopup() {
    // Create popup container
    const popup = document.createElement('div');
    popup.id = 'customization-popup';
    popup.className = 'customization-popup';
    popup.style.display = 'none';
    
    // Create popup content
    const popupContent = document.createElement('div');
    popupContent.className = 'popup-content';
    
    // Create header with tabs
    const header = document.createElement('div');
    header.className = 'popup-header';
    
    const colorTab = document.createElement('div');
    colorTab.className = 'popup-tab active';
    colorTab.setAttribute('data-tab', 'color');
    colorTab.textContent = 'Color';
    colorTab.addEventListener('click', () => this.switchTab('color'));
    
    const patternTab = document.createElement('div');
    patternTab.className = 'popup-tab';
    patternTab.setAttribute('data-tab', 'pattern');
    patternTab.textContent = 'Pattern';
    patternTab.addEventListener('click', () => this.switchTab('pattern'));
    
    const closeButton = document.createElement('button');
    closeButton.className = 'close-popup';
    closeButton.innerHTML = '&times;';
    closeButton.addEventListener('click', () => this.closePopup());
    
    header.appendChild(colorTab);
    header.appendChild(patternTab);
    header.appendChild(closeButton);
    
    // Create color picker tab content
    const colorContent = document.createElement('div');
    colorContent.className = 'tab-content';
    colorContent.id = 'color-tab';
    
    const colorWheel = document.createElement('div');
    colorWheel.className = 'color-wheel';
    
    // Create color wheel canvas
    const canvas = document.createElement('canvas');
    canvas.id = 'color-wheel-canvas';
    canvas.width = 200;
    canvas.height = 200;
    colorWheel.appendChild(canvas);
    
    // Create color preview
    const colorPreview = document.createElement('div');
    colorPreview.className = 'color-preview';
    colorPreview.id = 'color-preview';
    
    // Create apply button
    const applyColorButton = document.createElement('button');
    applyColorButton.className = 'apply-button';
    applyColorButton.textContent = 'Apply Color';
    applyColorButton.addEventListener('click', () => this.applyColor());
    
    colorContent.appendChild(colorWheel);
    colorContent.appendChild(colorPreview);
    colorContent.appendChild(applyColorButton);
    
    // Create pattern picker tab content
    const patternContent = document.createElement('div');
    patternContent.className = 'tab-content';
    patternContent.id = 'pattern-tab';
    patternContent.style.display = 'none';
    
    const patternGrid = document.createElement('div');
    patternGrid.className = 'pattern-grid';
    
    // Add patterns to grid
    this.availablePatterns.forEach(pattern => {
      const patternItem = document.createElement('div');
      patternItem.className = 'pattern-item';
      patternItem.setAttribute('data-pattern', pattern.id);
      
      const patternImg = document.createElement('img');
      patternImg.src = pattern.image;
      patternImg.alt = pattern.name;
      
      patternItem.appendChild(patternImg);
      patternItem.addEventListener('click', () => this.selectPattern(pattern));
      
      patternGrid.appendChild(patternItem);
    });
    
    // Create apply button
    const applyPatternButton = document.createElement('button');
    applyPatternButton.className = 'apply-button';
    applyPatternButton.textContent = 'Apply Pattern';
    applyPatternButton.addEventListener('click', () => this.applyPattern());
    
    patternContent.appendChild(patternGrid);
    patternContent.appendChild(applyPatternButton);
    
    // Assemble popup
    popupContent.appendChild(header);
    popupContent.appendChild(colorContent);
    popupContent.appendChild(patternContent);
    
    popup.appendChild(popupContent);
    
    // Add popup to body
    document.body.appendChild(popup);
    
    // Initialize color wheel
    this.initColorWheel();
    
    // Store references
    this.popup = popup;
    this.colorContent = colorContent;
    this.patternContent = patternContent;
    this.colorPreview = colorPreview;
  }

  initColorWheel() {
    const canvas = document.getElementById('color-wheel-canvas');
    const ctx = canvas.getContext('2d');
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const radius = Math.min(centerX, centerY) - 5;
    
    // Draw color wheel
    for (let angle = 0; angle < 360; angle++) {
      const startAngle = (angle - 1) * Math.PI / 180;
      const endAngle = (angle + 1) * Math.PI / 180;
      
      ctx.beginPath();
      ctx.moveTo(centerX, centerY);
      ctx.arc(centerX, centerY, radius, startAngle, endAngle);
      ctx.closePath();
      
      const hue = angle;
      ctx.fillStyle = `hsl(${hue}, 100%, 50%)`;
      ctx.fill();
    }
    
    // Draw white center
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius * 0.3, 0, Math.PI * 2);
    ctx.fillStyle = 'white';
    ctx.fill();
    
    // Add click event to select color
    canvas.addEventListener('click', (e) => {
      const rect = canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      
      const dx = x - centerX;
      const dy = y - centerY;
      const distance = Math.sqrt(dx * dx + dy * dy);
      
      if (distance <= radius) {
        // Inside color wheel
        if (distance <= radius * 0.3) {
          // White center
          this.setPreviewColor('white');
        } else {
          // Color ring
          let angle = Math.atan2(dy, dx) * 180 / Math.PI;
          if (angle < 0) angle += 360;
          
          const hue = angle;
          const saturation = Math.min(100, Math.max(0, (distance - radius * 0.3) / (radius * 0.7) * 100));
          const lightness = 50;
          
          this.setPreviewColor(`hsl(${hue}, ${saturation}%, ${lightness}%)`);
        }
      }
    });
  }

  setPreviewColor(color) {
    this.selectedColor = color;
    this.colorPreview.style.backgroundColor = color;
  }

  setupClothingItemListeners() {
    // Add click event to clothing items in avatar container
    document.addEventListener('DOMContentLoaded', () => {
      const avatarContainer = document.querySelector('.avatar-container');
      if (avatarContainer) {
        // Use event delegation for dynamically added clothing items
        avatarContainer.addEventListener('click', (e) => {
          const clothingItem = e.target.closest('.clothing-item');
          if (clothingItem) {
            this.openCustomizationPopup(clothingItem);
          }
        });
      }
    });
  }

  openCustomizationPopup(item) {
    this.currentItem = item;
    
    // Position popup near the item
    const itemRect = item.getBoundingClientRect();
    this.popup.style.top = `${itemRect.top + window.scrollY + itemRect.height / 2}px`;
    this.popup.style.left = `${itemRect.left + window.scrollX + itemRect.width}px`;
    
    // Show popup
    this.popup.style.display = 'block';
    
    // Reset to color tab
    this.switchTab('color');
  }

  closePopup() {
    this.popup.style.display = 'none';
    this.currentItem = null;
  }

  switchTab(tab) {
    this.currentTab = tab;
    
    // Update tab UI
    const tabs = this.popup.querySelectorAll('.popup-tab');
    tabs.forEach(t => {
      if (t.getAttribute('data-tab') === tab) {
        t.classList.add('active');
      } else {
        t.classList.remove('active');
      }
    });
    
    // Show/hide content
    if (tab === 'color') {
      this.colorContent.style.display = 'block';
      this.patternContent.style.display = 'none';
    } else {
      this.colorContent.style.display = 'none';
      this.patternContent.style.display = 'block';
    }
  }

  selectPattern(pattern) {
    this.selectedPattern = pattern;
    
    // Update UI to show selected pattern
    const patternItems = this.popup.querySelectorAll('.pattern-item');
    patternItems.forEach(item => {
      if (item.getAttribute('data-pattern') === pattern.id) {
        item.classList.add('selected');
      } else {
        item.classList.remove('selected');
      }
    });
  }

  applyColor() {
    if (this.currentItem && this.selectedColor) {
      // Apply color to the clothing item
      this.currentItem.style.filter = 'none'; // Remove any existing filters
      this.currentItem.style.backgroundColor = 'transparent'; // Reset background
      
      // Create a colored overlay
      let overlay = this.currentItem.querySelector('.color-overlay');
      if (!overlay) {
        overlay = document.createElement('div');
        overlay.className = 'color-overlay';
        overlay.style.position = 'absolute';
        overlay.style.top = '0';
        overlay.style.left = '0';
        overlay.style.width = '100%';
        overlay.style.height = '100%';
        overlay.style.mixBlendMode = 'multiply';
        overlay.style.pointerEvents = 'none';
        this.currentItem.style.position = 'relative';
        this.currentItem.appendChild(overlay);
      }
      
      overlay.style.backgroundColor = this.selectedColor;
      overlay.style.display = 'block';
      
      // Close popup
      this.closePopup();
      
      // Add sparkle effect
      this.addSparkleEffect(this.currentItem);
    }
  }

  applyPattern() {
    if (this.currentItem && this.selectedPattern) {
      // Apply pattern to the clothing item
      this.currentItem.style.filter = 'none'; // Remove any existing filters
      
      // Create a patterned background
      let patternOverlay = this.currentItem.querySelector('.pattern-overlay');
      if (!patternOverlay) {
        patternOverlay = document.createElement('div');
        patternOverlay.className = 'pattern-overlay';
        patternOverlay.style.position = 'absolute';
        patternOverlay.style.top = '0';
        patternOverlay.style.left = '0';
        patternOverlay.style.width = '100%';
        patternOverlay.style.height = '100%';
        patternOverlay.style.mixBlendMode = 'multiply';
        patternOverlay.style.pointerEvents = 'none';
        this.currentItem.style.position = 'relative';
        this.currentItem.appendChild(patternOverlay);
      }
      
      patternOverlay.style.backgroundImage = `url(${this.selectedPattern.image})`;
      patternOverlay.style.backgroundSize = 'cover';
      patternOverlay.style.display = 'block';
      
      // Hide color overlay if exists
      const colorOverlay = this.currentItem.querySelector('.color-overlay');
      if (colorOverlay) {
        colorOverlay.style.display = 'none';
      }
      
      // Close popup
      this.closePopup();
      
      // Add sparkle effect
      this.addSparkleEffect(this.currentItem);
    }
  }

  addSparkleEffect(item) {
    // Create sparkle elements around the clothing item
    const itemRect = item.getBoundingClientRect();
    
    for (let i = 0; i < 5; i++) {
      const sparkle = document.createElement('div');
      sparkle.className = 'sparkle';
      
      // Position randomly around the clothing item
      const top = Math.random() * itemRect.height;
      const left = Math.random() * itemRect.width;
      
      sparkle.style.position = 'absolute';
      sparkle.style.top = `${top}px`;
      sparkle.style.left = `${left}px`;
      sparkle.style.width = '10px';
      sparkle.style.height = '10px';
      sparkle.style.backgroundImage = 'radial-gradient(circle, white 0%, rgba(255,255,255,0) 70%)';
      sparkle.style.borderRadius = '50%';
      sparkle.style.pointerEvents = 'none';
      sparkle.style.zIndex = '100';
      sparkle.style.animation = `sparkle 2s ease-in-out`;
      
      item.appendChild(sparkle);
      
      // Remove sparkle after animation completes
      setTimeout(() => {
        sparkle.remove();
      }, 2000);
    }
  }
}

// Initialize the outfit customizer when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  const customizer = new OutfitCustomizer();
});
