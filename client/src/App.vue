<script setup>
import { ref, onMounted } from 'vue'
const API = 'http://localhost:4000/api/items'
const items = ref([])
const form = ref({ name: '', description: '', price: '' })
const editId = ref(null)

async function load() {
  items.value = await fetch(API).then(r => r.json())
}

async function save() {
  if (editId.value) {
    await fetch(`${API}/${editId.value}`, {
    method: 'PUT', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(form.value) })
    editId.value = null
  } else {
    await fetch(API, { method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(form.value) })
  }
  form.value = { name: '', description: '', price: '' }; load()
}

function startEdit(item) {
  editId.value = item.id
  form.value = { name: item.name, description: item.description, price: item.price }
}

async function remove(id) {
  await fetch(`${API}/${id}`, { method: 'DELETE' }); load()
}

onMounted(load)
</script>

<template>
  <main>
    <header>
      <div class="header-content">
        <div class="header-text">
          <h1>Items</h1>
          <p class="subtitle">Manage your product inventory</p>
        </div>
        <div class="header-stats">
          <div class="stat">
            <span class="stat-label">Total Items</span>
            <span class="stat-value">{{ items.length }}</span>
          </div>
        </div>
      </div>
    </header>

    <div class="content">
      <div class="form-section">
        <form @submit.prevent="save">
          <div class="form-group">
            <label>Product Name</label>
            <input v-model="form.name" placeholder="Enter product name" required />
          </div>
          
          <div class="form-row">
            <div class="form-group">
              <label>Description</label>
              <input v-model="form.description" placeholder="Product details" />
            </div>
            <div class="form-group">
              <label>Price (₱)</label>
              <input v-model.number="form.price" placeholder="0.00" type="number" step="0.01" />
            </div>
          </div>

          <button type="submit" class="btn-primary">{{ editId ? 'Update Item' : 'Add Item' }}</button>
        </form>
      </div>

      <div class="items-section">
        <h2>Products</h2>
        <ul v-if="items.length > 0">
          <li v-for="item in items" :key="item.id" class="item-card">
            <div class="item-info">
              <h3>{{ item.name }}</h3>
              <p class="item-description">{{ item.description }}</p>
              <p class="item-price">₱{{ item.price }}</p>
            </div>
            <div class="item-actions">
              <button @click="startEdit(item)" class="btn-edit">Edit</button>
              <button @click="remove(item.id)" class="btn-delete">Delete</button>
            </div>
          </li>
        </ul>
        <div v-else class="empty-state">
          <p>No items yet. Add one to get started!</p>
        </div>
      </div>
    </div>
  </main>
</template>

<style scoped>
main {
  width: 100%;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  background: #f9f9f9;
  min-height: 100vh;
  box-sizing: border-box;
}

header {
  width: 100%;
  padding: 0;
  background: #fff;
  border-bottom: 1px solid #e0e0e0;
  position: relative;
}

header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: #000;
}

.header-content {
  padding: 3rem 2rem;
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-text {
  flex: 1;
}

h1 {
  color: #000;
  font-size: 2.5rem;
  margin: 0 0 0.5rem 0;
  font-weight: 600;
  letter-spacing: -0.5px;
}

.subtitle {
  color: #999;
  font-size: 1rem;
  margin: 0;
  font-weight: 400;
}

.header-stats {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 1rem 2rem;
  background: #f9f9f9;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
}

.stat-label {
  color: #999;
  font-size: 0.85rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.5rem;
}

.stat-value {
  color: #000;
  font-size: 1.8rem;
  font-weight: 600;
}

.content {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 2rem;
  padding: 3rem 2rem;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

h2 {
  color: #000;
  font-size: 1.3rem;
  margin: 0 0 2rem 0;
  font-weight: 600;
}

.form-section {
  background: #fff;
  padding: 2.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  height: fit-content;
}

form {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
}

label {
  color: #333;
  font-size: 0.9rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

input {
  padding: 1rem;
  border: 1px solid #d0d0d0;
  border-radius: 6px;
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.2s ease;
  background: #fff;
}

input:focus {
  outline: none;
  background: #fff;
  border-color: #000;
  box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.05);
}

.btn-primary {
  padding: 1rem 2rem;
  background: #000;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-primary:hover {
  opacity: 0.85;
}

.items-section {
  background: #fff;
  padding: 2.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
}

ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.item-card {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1.5rem;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  gap: 1rem;
  transition: all 0.2s ease;
}

.item-card:hover {
  border-color: #d0d0d0;
  background: #fafafa;
}

.item-info {
  flex: 1;
}

.item-card h3 {
  color: #000;
  font-size: 1.1rem;
  margin: 0 0 0.5rem 0;
  font-weight: 600;
}

.item-description {
  color: #666;
  font-size: 0.95rem;
  margin: 0 0 0.75rem 0;
}

.item-price {
  color: #000;
  font-size: 1.2rem;
  margin: 0;
  font-weight: 600;
}

.item-actions {
  display: flex;
  gap: 0.75rem;
  white-space: nowrap;
  flex-shrink: 0;
}

.btn-edit,
.btn-delete {
  padding: 0.65rem 1.25rem;
  border: 1px solid #d0d0d0;
  background: #fff;
  color: #000;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.85rem;
  font-weight: 500;
  transition: all 0.2s ease;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.btn-edit:hover {
  background: #f0f0f0;
  border-color: #000;
}

.btn-delete:hover {
  background: #fff3f3;
  border-color: #d0d0d0;
}

.empty-state {
  text-align: center;
  padding: 3rem 2rem;
  color: #999;
  font-size: 1rem;
}

@media (max-width: 900px) {
  .content {
    grid-template-columns: 1fr;
  }

  .item-card {
    flex-direction: column;
  }

  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 1.5rem;
  }

  .header-stats {
    width: 100%;
  }
}
</style>