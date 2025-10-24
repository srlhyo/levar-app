import { Item } from '@/types/item';

const STORAGE_KEY = 'moving-items';

export const storage = {
  getItems: (): Item[] => {
    const data = localStorage.getItem(STORAGE_KEY);
    return data ? JSON.parse(data) : [];
  },

  setItems: (items: Item[]) => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  },

  addItem: (item: Item) => {
    const items = storage.getItems();
    items.push(item);
    storage.setItems(items);
  },

  updateItem: (id: string, updates: Partial<Item>) => {
    const items = storage.getItems();
    const index = items.findIndex(item => item.id === id);
    if (index !== -1) {
      items[index] = { ...items[index], ...updates };
      storage.setItems(items);
    }
  },

  deleteItem: (id: string) => {
    const items = storage.getItems().filter(item => item.id !== id);
    storage.setItems(items);
  },
};
