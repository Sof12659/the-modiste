// Copy of drag_and_drop.js for the public directory

document.addEventListener('DOMContentLoaded', function() {
    // Initialize drag-and-drop functionality
    initDragAndDrop();
    
    // Add visual feedback for draggable elements
    enhanceDraggableItems();
    
    // Add touch support for mobile devices
    addTouchSupport();
});

function initDragAndDrop() {
    // Make all clothing items draggable
    const clothingItems = document.querySelectorAll('.clothing-item-card');
    clothingItems.forEach(item => {
        item.setAttribute('draggable', 'true');
        
        item.addEventListener('dragstart', function(e) {
            // Store the item's ID in the drag data
            const itemId = this.getAttribute('data-item');
            e.dataTransfer.setData('text/plain', itemId);
            
            // Add a class to show it's being dragged
            this.classList.add('dragging');
            
            // Create a custom drag image
            const dragImage = this.querySelector('img').cloneNode(true);
            dragImage.style.width = '60px';
            dragImage.style.height = '60px';
            dragImage.style.opacity = '0.8';
            document.body.appendChild(dragImage);
            e.dataTransfer.setDragImage(dragImage, 30, 30);
            
            // Remove the clone after drag starts
            setTimeout(() => {
                document.body.removeChild(dragImage);
            }, 0);
        });
        
        item.addEventListener('dragend', function() {
            // Remove the dragging class
            this.classList.remove('dragging');
        });
    });
    
    // Make avatar container a drop target
    const avatarContainer = document.querySelector('.avatar-container');
    if (avatarContainer) {
        avatarContainer.addEventListener('dragover', function(e) {
            // Prevent default to allow drop
            e.preventDefault();
            
            // Add visual cue that this is a drop target
            this.classList.add('drag-over');
        });
        
        avatarContainer.addEventListener('dragleave', function() {
            // Remove visual cue
            this.classList.remove('drag-over');
        });
        
        avatarContainer.addEventListener('drop', function(e) {
            // Prevent default action
            e.preventDefault();
            
            // Remove visual cue
            this.classList.remove('drag-over');
            
            // Get the dragged item's ID
            const itemId = e.dataTransfer.getData('text/plain');
            
            // Find the item in the clothing grid
            const draggedItem = document.querySelector(`.clothing-item-card[data-item="${itemId}"]`);
            if (draggedItem) {
                // Trigger a click on the item to apply it to the avatar
                draggedItem.click();
                
                // Add drop animation
                addDropAnimation(e.clientX, e.clientY);
            }
        });
    }
}

function enhanceDraggableItems() {
    // Add visual cues and animations to draggable items
    const clothingItems = document.querySelectorAll('.clothing-item-card');
    clothingItems.forEach(item => {
        // Add a grab cursor
        item.style.cursor = 'grab';
        
        // Add a tooltip
        item.setAttribute('title', 'Drag to avatar or click to apply');
        
        // Add hover animation
        item.addEventListener('mouseenter', function() {
            this.classList.add('pulse');
        });
        
        item.addEventListener('mouseleave', function() {
            this.classList.remove('pulse');
        });
        
        // Add a subtle lift effect on hover
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 8px 15px rgba(0, 0, 0, 0.2)';
        });
        
        item.addEventListener('mouseleave', function() {
            this.style.transform = '';
            this.style.boxShadow = '';
        });
    });
    
    // Add a visual indicator to the avatar container
    const avatarContainer = document.querySelector('.avatar-container');
    if (avatarContainer) {
        // Create a drop zone indicator
        const dropZoneIndicator = document.createElement('div');
        dropZoneIndicator.className = 'drop-zone-indicator';
        dropZoneIndicator.textContent = 'Drop clothing here';
        dropZoneIndicator.style.display = 'none';
        avatarContainer.appendChild(dropZoneIndicator);
        
        // Show the indicator when an item is being dragged
        document.addEventListener('dragstart', function() {
            dropZoneIndicator.style.display = 'block';
        });
        
        document.addEventListener('dragend', function() {
            dropZoneIndicator.style.display = 'none';
        });
    }
}

function addTouchSupport() {
    // Add touch support for mobile devices
    const clothingItems = document.querySelectorAll('.clothing-item-card');
    const avatarContainer = document.querySelector('.avatar-container');
    
    if (!avatarContainer) return;
    
    clothingItems.forEach(item => {
        item.addEventListener('touchstart', function(e) {
            // Prevent default to avoid scrolling
            e.preventDefault();
            
            // Store the touched item
            window.touchedItem = this;
            
            // Add visual feedback
            this.classList.add('touching');
            
            // Create a floating copy that follows the finger
            const floatingCopy = this.querySelector('img').cloneNode(true);
            floatingCopy.className = 'floating-item';
            floatingCopy.style.position = 'absolute';
            floatingCopy.style.width = '60px';
            floatingCopy.style.height = '60px';
            floatingCopy.style.opacity = '0.8';
            floatingCopy.style.zIndex = '1000';
            floatingCopy.style.pointerEvents = 'none';
            floatingCopy.style.top = `${e.touches[0].clientY - 30}px`;
            floatingCopy.style.left = `${e.touches[0].clientX - 30}px`;
            document.body.appendChild(floatingCopy);
            window.floatingCopy = floatingCopy;
        });
        
        item.addEventListener('touchend', function(e) {
            // Remove visual feedback
            this.classList.remove('touching');
            
            // Remove the floating copy
            if (window.floatingCopy) {
                document.body.removeChild(window.floatingCopy);
                window.floatingCopy = null;
            }
            
            // Check if the touch ended over the avatar container
            const touch = e.changedTouches[0];
            const avatarRect = avatarContainer.getBoundingClientRect();
            
            if (
                touch.clientX >= avatarRect.left &&
                touch.clientX <= avatarRect.right &&
                touch.clientY >= avatarRect.top &&
                touch.clientY <= avatarRect.bottom
            ) {
                // Touch ended over avatar, apply the item
                this.click();
                
                // Add drop animation
                addDropAnimation(touch.clientX, touch.clientY);
            }
            
            window.touchedItem = null;
        });
        
        item.addEventListener('touchmove', function(e) {
            // Move the floating copy with the finger
            if (window.floatingCopy) {
                window.floatingCopy.style.top = `${e.touches[0].clientY - 30}px`;
                window.floatingCopy.style.left = `${e.touches[0].clientX - 30}px`;
            }
            
            // Check if touch is over avatar container
            const touch = e.touches[0];
            const avatarRect = avatarContainer.getBoundingClientRect();
            
            if (
                touch.clientX >= avatarRect.left &&
                touch.clientX <= avatarRect.right &&
                touch.clientY >= avatarRect.top &&
                touch.clientY <= avatarRect.bottom
            ) {
                // Highlight avatar container
                avatarContainer.classList.add('drag-over');
            } else {
                // Remove highlight
                avatarContainer.classList.remove('drag-over');
            }
        });
    });
}

function addDropAnimation(x, y) {
    // Create sparkle effect at drop point
    for (let i = 0; i < 10; i++) {
        const sparkle = document.createElement('div');
        sparkle.className = 'sparkle';
        sparkle.style.top = `${y - 5 + Math.random() * 10}px`;
        sparkle.style.left = `${x - 5 + Math.random() * 10}px`;
        sparkle.style.width = `${Math.random() * 10 + 5}px`;
        sparkle.style.height = `${Math.random() * 10 + 5}px`;
        document.body.appendChild(sparkle);
        
        // Remove sparkle after animation
        setTimeout(() => {
            sparkle.remove();
        }, 2000);
    }
    
    // Add a ripple effect
    const ripple = document.createElement('div');
    ripple.className = 'ripple';
    ripple.style.top = `${y}px`;
    ripple.style.left = `${x}px`;
    ripple.style.position = 'absolute';
    ripple.style.width = '0';
    ripple.style.height = '0';
    ripple.style.borderRadius = '50%';
    ripple.style.backgroundColor = 'rgba(255, 215, 0, 0.3)';
    ripple.style.zIndex = '999';
    ripple.style.pointerEvents = 'none';
    document.body.appendChild(ripple);
    
    // Animate the ripple
    let size = 0;
    const rippleInterval = setInterval(() => {
        size += 10;
        ripple.style.width = `${size}px`;
        ripple.style.height = `${size}px`;
        ripple.style.top = `${y - size/2}px`;
        ripple.style.left = `${x - size/2}px`;
        ripple.style.opacity = 1 - size/200;
        
        if (size >= 200) {
            clearInterval(rippleInterval);
            ripple.remove();
        }
    }, 20);
}

// Add CSS styles for drag-and-drop visual feedback
const style = document.createElement('style');
style.textContent = `
    .dragging {
        opacity: 0.6;
    }
    
    .drag-over {
        box-shadow: 0 0 20px rgba(255, 215, 0, 0.8);
    }
    
    .touching {
        opacity: 0.6;
    }
    
    .ripple {
        transition: all 0.3s ease-out;
    }
    
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); }
    }
    
    .pulse {
        animation: pulse 0.5s infinite;
    }
    
    .floating-bubble {
        position: absolute;
        border-radius: 50%;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.8), rgba(255, 133, 194, 0.3));
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: 1;
    }
`;
document.head.appendChild(style);
