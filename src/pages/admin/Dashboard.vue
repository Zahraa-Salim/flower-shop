<!-- Dashboard.vue — Admin panel for managing products and orders -->
<template>
  <section class="min-h-screen bg-gradient-to-b from-slate-50 via-white to-emerald-50 px-4 py-10 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-7xl space-y-8">
      <div class="rounded-[2rem] bg-white/90 p-8 shadow-sm ring-1 ring-slate-200">
        <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div class="space-y-3">
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-emerald-500">Admin Panel</p>
            <h1 class="text-4xl font-semibold tracking-tight text-slate-950 sm:text-5xl">Dashboard</h1>
            <p class="max-w-2xl text-base leading-7 text-slate-600">
              Manage the flower catalog and track incoming orders from one clean workspace.
            </p>
          </div>

          <div class="inline-flex rounded-full bg-slate-100 p-1">
            <button
              class="rounded-full px-5 py-2 text-sm font-semibold transition"
              :class="activeTab === 'products' ? 'bg-white text-slate-950 shadow-sm' : 'text-slate-500 hover:text-slate-900'"
              type="button"
              @click="activeTab = 'products'"
            >
              Products
            </button>
            <button
              class="rounded-full px-5 py-2 text-sm font-semibold transition"
              :class="activeTab === 'orders' ? 'bg-white text-slate-950 shadow-sm' : 'text-slate-500 hover:text-slate-900'"
              type="button"
              @click="activeTab = 'orders'"
            >
              Orders
            </button>
          </div>
        </div>
      </div>

      <section
        v-if="activeTab === 'products'"
        class="space-y-6"
      >
        <div class="flex flex-col gap-4 rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-slate-200 lg:flex-row lg:items-start lg:justify-between">
          <div>
            <h2 class="text-2xl font-semibold text-slate-950">Products</h2>
            <p class="mt-1 text-sm text-slate-500">Add, update, and retire bouquets from your storefront.</p>
          </div>

          <button
            class="rounded-full bg-emerald-500 px-5 py-3 text-sm font-semibold text-white transition hover:bg-emerald-600"
            type="button"
            @click="startCreateProduct"
          >
            Add Product
          </button>
        </div>

        <div
          v-if="productFormOpen"
          class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-slate-200 sm:p-8"
        >
          <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <h3 class="text-2xl font-semibold text-slate-950">
                {{ editingProductId ? 'Edit Product' : 'Add Product' }}
              </h3>
              <p class="mt-1 text-sm text-slate-500">Fill in the details below to update the catalog.</p>
            </div>

            <button
              class="rounded-full border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600 transition hover:bg-slate-50"
              type="button"
              @click="closeProductForm"
            >
              Cancel
            </button>
          </div>

          <form
            class="mt-6 grid gap-5 sm:grid-cols-2"
            @submit.prevent="submitProductForm"
          >
            <label class="block space-y-2">
              <span class="text-sm font-medium text-slate-900">Name</span>
              <input
                v-model="productForm.name"
                class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                type="text"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-slate-900">Type</span>
              <input
                v-model="productForm.type"
                class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                type="text"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-slate-900">Price</span>
              <input
                v-model.number="productForm.price"
                class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                type="number"
                min="0"
                step="0.01"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-slate-900">Stock</span>
              <input
                v-model.number="productForm.stock"
                class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                type="number"
                min="0"
                step="1"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-slate-900">Color</span>
              <input
                v-model="productForm.color"
                class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                type="text"
                required
              />
            </label>

            <label class="block space-y-2">
              <span class="text-sm font-medium text-slate-900">Image URL</span>
              <input
                v-model="productForm.image_url"
                class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                type="url"
                required
              />
            </label>

            <label class="block space-y-2 sm:col-span-2">
              <span class="text-sm font-medium text-slate-900">Description</span>
              <textarea
                v-model="productForm.description"
                class="min-h-28 w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                required
              />
            </label>

            <label class="flex items-center gap-3 rounded-2xl bg-slate-50 px-4 py-4 text-sm font-medium text-slate-900 sm:col-span-2">
              <input
                v-model="productForm.is_available"
                class="h-4 w-4 rounded border-slate-300 text-emerald-500 focus:ring-emerald-300"
                type="checkbox"
              />
              Available for sale
            </label>

            <p
              v-if="productErrorMessage"
              class="rounded-2xl bg-rose-50 px-4 py-3 text-sm font-medium text-rose-700 sm:col-span-2"
            >
              {{ productErrorMessage }}
            </p>

            <div class="sm:col-span-2">
              <button
                class="rounded-full bg-emerald-500 px-6 py-3 text-sm font-semibold text-white transition hover:bg-emerald-600 disabled:cursor-not-allowed disabled:bg-emerald-200"
                type="submit"
                :disabled="productSubmitting"
              >
                {{ productSubmitting ? 'Saving...' : editingProductId ? 'Update Product' : 'Create Product' }}
              </button>
            </div>
          </form>
        </div>

        <div class="overflow-x-auto rounded-[2rem] bg-white/90 shadow-sm ring-1 ring-slate-200">
          <table class="min-w-full text-left">
            <thead class="bg-slate-50 text-sm font-semibold text-slate-600">
              <tr>
                <th class="px-5 py-4">Image</th>
                <th class="px-5 py-4">Name</th>
                <th class="px-5 py-4">Type</th>
                <th class="px-5 py-4">Price</th>
                <th class="px-5 py-4">Stock</th>
                <th class="px-5 py-4">Available</th>
                <th class="px-5 py-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="product in products"
                :key="product.id"
                class="border-t border-slate-100 text-sm text-slate-700"
              >
                <td class="px-5 py-4">
                  <div class="h-14 w-14 overflow-hidden rounded-2xl bg-slate-100">
                    <img
                      :src="product.image_url || fallbackImage"
                      :alt="product.name"
                      class="h-full w-full object-cover"
                    />
                  </div>
                </td>
                <td class="px-5 py-4 font-medium text-slate-950">{{ product.name }}</td>
                <td class="px-5 py-4">{{ product.type }}</td>
                <td class="px-5 py-4">${{ product.price.toFixed(2) }}</td>
                <td class="px-5 py-4">{{ product.stock }}</td>
                <td class="px-5 py-4">
                  <span
                    class="rounded-full px-3 py-1 text-xs font-semibold"
                    :class="product.is_available ? 'bg-emerald-50 text-emerald-700' : 'bg-rose-50 text-rose-700'"
                  >
                    {{ product.is_available ? 'Yes' : 'No' }}
                  </span>
                </td>
                <td class="px-5 py-4">
                  <div class="flex flex-wrap gap-2">
                    <button
                      class="rounded-full border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-700 transition hover:bg-slate-50"
                      type="button"
                      @click="startEditProduct(product)"
                    >
                      Edit
                    </button>
                    <button
                      class="rounded-full border border-rose-200 px-4 py-2 text-xs font-semibold text-rose-700 transition hover:bg-rose-50"
                      type="button"
                      @click="deleteProduct(product.id)"
                    >
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
              <tr v-if="products.length === 0">
                <td
                  class="px-5 py-10 text-center text-sm text-slate-500"
                  colspan="7"
                >
                  No products found.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section
        v-else
        class="space-y-6"
      >
        <div class="rounded-[2rem] bg-white/90 p-6 shadow-sm ring-1 ring-slate-200">
          <h2 class="text-2xl font-semibold text-slate-950">Orders</h2>
          <p class="mt-1 text-sm text-slate-500">Track customer orders and update their fulfillment status.</p>
        </div>

        <div class="overflow-x-auto rounded-[2rem] bg-white/90 shadow-sm ring-1 ring-slate-200">
          <table class="min-w-full text-left">
            <thead class="bg-slate-50 text-sm font-semibold text-slate-600">
              <tr>
                <th class="px-5 py-4">ID</th>
                <th class="px-5 py-4">User</th>
                <th class="px-5 py-4">Total</th>
                <th class="px-5 py-4">Status</th>
                <th class="px-5 py-4">Delivery Date</th>
                <th class="px-5 py-4">Created At</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="order in orders"
                :key="order.id"
                class="border-t border-slate-100 text-sm text-slate-700"
              >
                <td class="px-5 py-4 font-medium text-slate-950">#{{ order.id }}</td>
                <td class="px-5 py-4">{{ getOrderUserLabel(order) }}</td>
                <td class="px-5 py-4">${{ order.total_price.toFixed(2) }}</td>
                <td class="px-5 py-4">
                  <select
                    class="rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-950 outline-none transition focus:border-emerald-300 focus:bg-white"
                    :value="order.status"
                    @change="updateOrderStatus(order, $event)"
                  >
                    <option
                      v-for="status in orderStatuses"
                      :key="status"
                      :value="status"
                    >
                      {{ status }}
                    </option>
                  </select>
                </td>
                <td class="px-5 py-4">{{ formatDate(order.delivery_date) }}</td>
                <td class="px-5 py-4">{{ formatDate(order.created_at) }}</td>
              </tr>
              <tr v-if="orders.length === 0">
                <td
                  class="px-5 py-10 text-center text-sm text-slate-500"
                  colspan="6"
                >
                  No orders found.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </section>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { supabase } from '@/lib/supabase'

type AdminTab = 'products' | 'orders'

interface AdminProduct {
  id: number
  name: string
  description: string
  price: number
  stock: number
  image_url: string
  type: string
  color: string
  is_available: boolean
}

interface OrderUser {
  full_name: string | null
}

interface AdminOrder {
  id: number
  user_id: string
  total_price: number
  status: string
  delivery_date: string
  created_at: string
  users: OrderUser | OrderUser[] | null
}

interface ProductFormState {
  name: string
  description: string
  price: number
  stock: number
  image_url: string
  type: string
  color: string
  is_available: boolean
}

const fallbackImage =
  'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?auto=format&fit=crop&w=900&q=80'

const orderStatuses = ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled']

const createEmptyProductForm = (): ProductFormState => ({
  name: '',
  description: '',
  price: 0,
  stock: 0,
  image_url: '',
  type: '',
  color: '',
  is_available: true
})

const activeTab = ref<AdminTab>('products')
const products = ref<AdminProduct[]>([])
const orders = ref<AdminOrder[]>([])
const productForm = ref<ProductFormState>(createEmptyProductForm())
const productFormOpen = ref(false)
const editingProductId = ref<number | null>(null)
const productSubmitting = ref(false)
const productErrorMessage = ref('')

const formatDate = (value: string) =>
  new Date(value).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })

const getOrderUserLabel = (order: AdminOrder) => {
  if (Array.isArray(order.users)) {
    return order.users[0]?.full_name || `User ${order.user_id.slice(0, 8)}`
  }

  return order.users?.full_name || `User ${order.user_id.slice(0, 8)}`
}

const fetchProducts = async () => {
  const { data } = await supabase.from('products').select('*').order('id', { ascending: true })
  products.value = (data as AdminProduct[] | null) ?? []
}

const fetchOrders = async () => {
  const { data } = await supabase
    .from('orders')
    .select('id, user_id, total_price, status, delivery_date, created_at, users(full_name)')
    .order('created_at', { ascending: false })

  orders.value = (data as AdminOrder[] | null) ?? []
}

const startCreateProduct = () => {
  editingProductId.value = null
  productForm.value = createEmptyProductForm()
  productErrorMessage.value = ''
  productFormOpen.value = true
}

const startEditProduct = (product: AdminProduct) => {
  editingProductId.value = product.id
  productForm.value = {
    name: product.name,
    description: product.description,
    price: product.price,
    stock: product.stock,
    image_url: product.image_url,
    type: product.type,
    color: product.color,
    is_available: product.is_available
  }
  productErrorMessage.value = ''
  productFormOpen.value = true
}

const closeProductForm = () => {
  productFormOpen.value = false
  editingProductId.value = null
  productForm.value = createEmptyProductForm()
  productErrorMessage.value = ''
}

const submitProductForm = async () => {
  productSubmitting.value = true
  productErrorMessage.value = ''

  if (editingProductId.value) {
    const { error } = await supabase
      .from('products')
      .update(productForm.value)
      .eq('id', editingProductId.value)

    if (error) {
      productErrorMessage.value = error.message
      productSubmitting.value = false
      return
    }
  } else {
    const { error } = await supabase.from('products').insert(productForm.value)

    if (error) {
      productErrorMessage.value = error.message
      productSubmitting.value = false
      return
    }
  }

  await fetchProducts()
  closeProductForm()
  productSubmitting.value = false
}

const deleteProduct = async (productId: number) => {
  const shouldDelete = window.confirm('Delete this product? This action cannot be undone.')

  if (!shouldDelete) {
    return
  }

  const { error } = await supabase.from('products').delete().eq('id', productId)

  if (error) {
    productErrorMessage.value = error.message
    return
  }

  products.value = products.value.filter((product) => product.id !== productId)
}

const updateOrderStatus = async (order: AdminOrder, event: Event) => {
  const target = event.target as HTMLSelectElement
  const nextStatus = target.value
  const previousStatus = order.status

  order.status = nextStatus

  const { error } = await supabase.from('orders').update({ status: nextStatus }).eq('id', order.id)

  if (error) {
    order.status = previousStatus
  }
}

onMounted(() => {
  void fetchProducts()
  void fetchOrders()
})
</script>
