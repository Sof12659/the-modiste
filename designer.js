// Designer Page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize fabric.js canvas
    const canvas = new fabric.Canvas('outfit-canvas', {
        width: document.querySelector('.design-canvas').clientWidth,
        height: document.querySelector('.design-canvas').clientHeight,
        backgroundColor: '#FFFFFF'
    });

    // Hide placeholder when canvas is initialized
    document.querySelector('.canvas-placeholder').style.display = 'none';

    // Category tabs functionality
    const categoryTabs = document.querySelectorAll('.category-tab');
    const categoryItems = document.querySelectorAll('.category-items');

    categoryTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Remove active class from all tabs and items
            categoryTabs.forEach(t => t.classList.remove('active'));
            categoryItems.forEach(i => i.classList.remove('active'));
            
            // Add active class to clicked tab
            this.classList.add('active');
            
            // Show corresponding items
            const category = this.getAttribute('data-category');
            document.getElementById(`${category}-items`).classList.add('active');
        });
    });

    // View controls functionality
    const viewButtons = document.querySelectorAll('.view-btn');
    let currentView = 'front';

    viewButtons.forEach(button => {
        button.addEventListener('click', function() {
            viewButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            const view = this.getAttribute('data-view');
            currentView = view;
            
            // In a real implementation, this would switch the model view
            console.log(`Switched to ${view} view`);
        });
    });

    // Drag and drop functionality
    const items = document.querySelectorAll('.item');
    let selectedObject = null;

    items.forEach(item => {
        item.addEventListener('dragstart', function(e) {
            e.dataTransfer.setData('text/plain', JSON.stringify({
                type: this.getAttribute('data-item-type'),
                id: this.getAttribute('data-item-id')
            }));
        });
    });

    const designCanvas = document.querySelector('.design-canvas');
    
    designCanvas.addEventListener('dragover', function(e) {
        e.preventDefault();
    });
    
    designCanvas.addEventListener('drop', function(e) {
        e.preventDefault();
        
        try {
            const data = JSON.parse(e.dataTransfer.getData('text/plain'));
            addItemToCanvas(data.type, data.id, e.offsetX, e.offsetY);
        } catch (error) {
            console.error('Error adding item to canvas:', error);
        }
    });

    // Function to add item to canvas
    function addItemToCanvas(type, id, x, y) {
        const imageMap = {
            top: 'images/clothing/shirt.png',
            bottom: 'images/clothing/jeans.png',
            dress: 'images/clothing/dress.png',
            outerwear: 'images/clothing/sweater.png',
            accessory: 'images/clothing/bracelet.png'
        };
    
        const url = imageMap[type] || 'images/clothing/shirt.png';
    
        fabric.Image.fromURL(url, function(img) {
            img.set({
                left: x,
                top: y,
                scaleX: 0.5,
                scaleY: 0.5,
                hasControls: true,
                hasBorders: true,
                itemType: type,
                itemId: id
            });
    
            canvas.add(img);
            canvas.setActiveObject(img);
            selectedObject = img;
        });
    }
    
        
        
        const rect = new fabric.Rect({
            left: x,
            top: y,
            width: sizes[type].width,
            height: sizes[type].height,
            fill: colors[type] || '#CCCCCC',
            stroke: '#999999',
            strokeWidth: 1,
            rx: 10,
            ry: 10,
            originX: 'center',
            originY: 'center',
            itemType: type,
            itemId: id
        });
        
        canvas.add(rect);
        canvas.setActiveObject(rect);
        selectedObject = rect;
        
        console.log(`Added ${type} item (ID: ${id}) to canvas`);
    }

    // Canvas control buttons functionality
    document.getElementById('zoom-in').addEventListener('click', function() {
        const zoom = canvas.getZoom();
        canvas.setZoom(zoom * 1.1);
    });
    
    document.getElementById('zoom-out').addEventListener('click', function() {
        const zoom = canvas.getZoom();
        canvas.setZoom(zoom / 1.1);
    });
    
    document.getElementById('rotate').addEventListener('click', function() {
        if (canvas.getActiveObject()) {
            const object = canvas.getActiveObject();
            object.rotate(object.angle + 15);
            canvas.renderAll();
        }
    });
    
    document.getElementById('bring-forward').addEventListener('click', function() {
        if (canvas.getActiveObject()) {
            canvas.bringForward(canvas.getActiveObject());
        }
    });
    
    document.getElementById('send-backward').addEventListener('click', function() {
        if (canvas.getActiveObject()) {
            canvas.sendBackwards(canvas.getActiveObject());
        }
    });
    
    document.getElementById('delete-item').addEventListener('click', function() {
        if (canvas.getActiveObject()) {
            canvas.remove(canvas.getActiveObject());
        }
    });

    // Color picker functionality
    const colorOptions = document.querySelectorAll('.color-option');
    
    colorOptions.forEach(option => {
        if (!option.classList.contains('custom-color')) {
            option.addEventListener('click', function() {
                const color = this.getAttribute('data-color');
                applyColorToSelectedObject(color);
                
                // Update selected state
                colorOptions.forEach(o => o.classList.remove('selected'));
                this.classList.add('selected');
            });
        }
    });
    
    document.getElementById('custom-color-picker').addEventListener('input', function() {
        const color = this.value;
        applyColorToSelectedObject(color);
        
        // Update selected state
        colorOptions.forEach(o => o.classList.remove('selected'));
        this.parentElement.classList.add('selected');
    });
    
    function applyColorToSelectedObject(color) {
        if (canvas.getActiveObject()) {
            canvas.getActiveObject().set('fill', color);
            canvas.renderAll();
        }
    }

    // Pattern picker functionality
    const patternOptions = document.querySelectorAll('.pattern-option');
    
    patternOptions.forEach(option => {
        option.addEventListener('click', function() {
            const pattern = this.getAttribute('data-pattern');
            applyPatternToSelectedObject(pattern);
            
            // Update selected state
            patternOptions.forEach(o => o.classList.remove('selected'));
            this.classList.add('selected');
        });
    });
    
    function applyPatternToSelectedObject(pattern) {
        if (canvas.getActiveObject()) {
            // In a real implementation, this would apply actual patterns
            // For now, we'll just log the action
            console.log(`Applied pattern ${pattern} to selected object`);
            
            if (pattern === 'none') {
                canvas.getActiveObject().set('fill', canvas.getActiveObject().fill);
            } else {
                // Simulate pattern with opacity
                canvas.getActiveObject().set('opacity', 0.8);
            }
            
            canvas.renderAll();
        }
    }

    // Material selector functionality
    document.getElementById('material-select').addEventListener('change', function() {
        const material = this.value;
        
        if (canvas.getActiveObject()) {
            // In a real implementation, this would apply material textures
            console.log(`Applied material ${material} to selected object`);
        }
    });

    // Style modifiers functionality
    const styleModifiers = document.querySelectorAll('.modifier-group select');
    
    styleModifiers.forEach(modifier => {
        modifier.addEventListener('change', function() {
            if (canvas.getActiveObject()) {
                const modifierType = this.parentElement.id.split('-')[0];
                const value = this.value;
                
                // In a real implementation, this would modify the item style
                console.log(`Applied ${modifierType} style ${value} to selected object`);
            }
        });
    });

    // Save and search buttons functionality
    document.getElementById('save-design').addEventListener('click', function() {
        // In a real implementation, this would save the design to the server
        alert('Design saved to your gallery!');
    });
    
    document.getElementById('search-matches').addEventListener('click', function() {
        // In a real implementation, this would trigger the AI search
        window.location.href = 'search-results.html';
    });

    // Handle window resize
    window.addEventListener('resize', function() {
        canvas.setWidth(document.querySelector('.design-canvas').clientWidth);
        canvas.setHeight(document.querySelector('.design-canvas').clientHeight);
        canvas.renderAll();
    });

    // Select object on canvas click
    canvas.on('selection:created', function(options) {
        selectedObject = options.selected[0];
        updateStyleControls();
    });
    
    canvas.on('selection:updated', function(options) {
        selectedObject = options.selected[0];
        updateStyleControls();
    });
    
    canvas.on('selection:cleared', function() {
        selectedObject = null;
    });
    
    function updateStyleControls() {
        // In a real implementation, this would update the style controls
        // based on the selected object's properties
        console.log('Updated style controls for selected object');
    }

    // Initialize canvas with a silhouette
    function addSilhouette() {
        fabric.Image.fromURL('images/silhouette.svg', function(img) {
            img.set({
                left: canvas.width / 2,
                top: canvas.height / 2,
                originX: 'center',
                originY: 'center',
                selectable: false,
                opacity: 0.2
            });
            canvas.add(img);
            canvas.sendToBack(img);
        });
    }
    
    // Uncomment this when silhouette image is available
    // addSilhouette();
});
