// js/avatar_outfit_designer.js

class OutfitDesigner {
  constructor() {
    this.avatarContainer = document.getElementById('avatar-container');
    this.currentOutfit   = { tops: null, bottoms: null, dresses: null };
    this.availableItems  = { tops: [], bottoms: [], dresses: [] };
    this.currentCategory = 'tops';
    this.init();
  }

  init() {
    this.loadAvatarBase();
    this.loadClothingItems();
    this.setupEventListeners();
    this.addDecorativeElements();
  }

  loadAvatarBase() {
    // Avatar image
    const avatar = document.createElement('img');
    avatar.className = 'fashion-avatar';
    avatar.src       = 'images/avatars/avatar-base.png';
    avatar.alt       = 'Avatar';
    this.avatarContainer.appendChild(avatar);

    // Platform (optional)
    const platform = document.createElement('div');
    platform.className = 'avatar-platform pulse';
    this.avatarContainer.appendChild(platform);
  }

  loadClothingItems() {
    this.availableItems.tops = [
      { id:'sweater', name:'Sweater', image:'images/clothing/sweater.png', width:'160px' },
      { id:'shirt',   name:'Shirt',   image:'images/clothing/shirt.png',   width:'160px' },
      { id:'blazer',  name:'Blazer',  image:'images/clothing/blazer.png',  width:'160px' }
    ];
    this.availableItems.bottoms = [
      { id:'jeans', name:'Jeans', image:'images/clothing/jeans.png', width:'160px' }
    ];
    this.availableItems.dresses = [
      { id:'dress', name:'Dress', image:'images/clothing/dress.png', width:'160px' }
    ];
    this.updateClothingGrid();
  }

  setupEventListeners() {
    document.querySelectorAll('.category-button').forEach(btn => {
      btn.onclick = () => this.changeCategory(btn.dataset.category);
    });
    document.getElementById('save-design').onclick   = () => this.saveOutfit();
    document.getElementById('find-matches').onclick = () => this.findMatches();
  }

  changeCategory(cat) {
    this.currentCategory = cat;
    document.querySelector('.category-title').textContent =
      cat.charAt(0).toUpperCase() + cat.slice(1);
    document.querySelectorAll('.category-button').forEach(b => {
      b.classList.toggle('active', b.dataset.category === cat);
    });
    this.updateClothingGrid();
  }

  updateClothingGrid() {
    const grid = document.getElementById('clothing-grid');
    grid.innerHTML = '';
    this.availableItems[this.currentCategory].forEach(item => {
      const card = document.createElement('div');
      card.className = 'clothing-item-card';
      card.setAttribute('data-item', item.id);

      const img = document.createElement('img');
      img.src = item.image;
      img.alt = item.name;

      card.appendChild(img);
      grid.appendChild(card);

      card.addEventListener('click', () => this.applyClothing(item));
    });
  }

  applyClothing(item) {
    // Remove old
    const old = document.getElementById(this.currentCategory);
    if (old) old.remove();

    // Handle dresses vs tops/bottoms
    if (this.currentCategory === 'dresses') {
      ['tops','bottoms'].forEach(c => {
        const el = document.getElementById(c);
        if (el) el.remove();
        this.currentOutfit[c] = null;
      });
    } else {
      const d = document.getElementById('dresses');
      if (d) d.remove();
      this.currentOutfit.dresses = null;
    }

    this.currentOutfit[this.currentCategory] = item;
    this.addClothingItemToAvatar(item, this.currentCategory);
  }

  addClothingItemToAvatar(item, identifier) {
    // 1) Create the image and disable native drag
    const el = document.createElement('img');
    el.src = item.image;
    el.alt = item.name;
    el.id = identifier;
    el.className = 'clothing-item';
    el.draggable = false;
    el.style.userSelect = 'none';
    el.style.position = 'absolute';
    el.style.width    = item.width;
    el.style.cursor   = 'grab';
    el.style.zIndex   = '10';
  
    // 2) Append to container
    this.avatarContainer.appendChild(el);
  
    // 3) Compute spawn position
    const H = this.avatarContainer.clientHeight;
    const W = this.avatarContainer.clientWidth;
    const iw = parseInt(item.width, 10);
    el.style.left = ((W - iw) / 2) + 'px';
    el.style.top  = this.currentCategory === 'tops'
                    ? (H * 0.25) + 'px'
                    : this.currentCategory === 'bottoms'
                      ? (H * 0.6) + 'px'
                      : (H * 0.35) + 'px';
  
    // 4) Attach mousedown handler
    el.addEventListener('mousedown', e => {
      console.log('mousedown on', identifier);  // ← check this in your console
      e.preventDefault();
  
      const startX = e.clientX;
      const startY = e.clientY;
      const origX = parseFloat(el.style.left);
      const origY = parseFloat(el.style.top);
      el.style.cursor = 'grabbing';
  
      // mousemove on document
      const onMouseMove = evt => {
        const dx = evt.clientX - startX;
        const dy = evt.clientY - startY;
        el.style.left = (origX + dx) + 'px';
        el.style.top  = (origY + dy) + 'px';
      };
  
      // mouseup cleans up
      const onMouseUp = () => {
        el.style.cursor = 'grab';
        document.removeEventListener('mousemove', onMouseMove);
        document.removeEventListener('mouseup',   onMouseUp);
      };
  
      document.addEventListener('mousemove', onMouseMove);
      document.addEventListener('mouseup',   onMouseUp);
    });
  }
  
    
  

  addDecorativeElements() {
    setInterval(() => {
      const s = document.createElement('div');
      s.className = 'sparkle';
      s.style.top  = Math.random()*100 + '%';
      s.style.left = Math.random()*100 + '%';
      this.avatarContainer.appendChild(s);
      setTimeout(() => s.remove(), 2000);
    }, 500);
  }

  saveOutfit()   { alert('Saved to gallery!'); }
  findMatches()  { alert('Searching for matches...'); }
}

document.addEventListener('DOMContentLoaded', () => new OutfitDesigner());
