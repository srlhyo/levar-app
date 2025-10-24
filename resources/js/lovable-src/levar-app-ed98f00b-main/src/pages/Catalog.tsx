import { useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { Camera, ArrowLeft, Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import { storage } from '@/lib/storage';
import { Item } from '@/types/item';
import { toast } from 'sonner';

const Catalog = () => {
  const navigate = useNavigate();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [photo, setPhoto] = useState<string>('');
  const [name, setName] = useState('');
  const [notes, setNotes] = useState('');
  const [weight, setWeight] = useState('');

  const handlePhotoCapture = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setPhoto(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!name.trim()) {
      toast.error('Por favor, dê um nome ao item');
      return;
    }

    const newItem: Item = {
      id: Date.now().toString(),
      name: name.trim(),
      photo: photo || undefined,
      notes: notes.trim() || undefined,
      weight: parseFloat(weight) || 0,
      decision: 'pending',
      packed: false,
      luggage: null,
      createdAt: new Date().toISOString(),
    };

    storage.addItem(newItem);
    toast.success(`${name} adicionado!`);

    // Reset form
    setPhoto('');
    setName('');
    setNotes('');
    setWeight('');
  };

  return (
    <div className="min-h-screen bg-catalog-secondary">
      <div className="bg-gradient-catalog text-white p-6 shadow-smooth-md">
        <div className="flex items-center gap-4 mb-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => navigate('/')}
            className="text-white hover:bg-white/20"
          >
            <ArrowLeft className="h-6 w-6" />
          </Button>
          <h1 className="text-2xl font-bold">Catalogar</h1>
        </div>
        <p className="text-white/90 text-sm">Tire fotos e adicione informações dos seus itens</p>
      </div>

      <div className="p-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="bg-card rounded-xl p-6 shadow-smooth-sm space-y-4">
            {/* Photo Section */}
            <div>
              <Label className="text-catalog">Foto</Label>
              <div className="mt-2">
                {photo ? (
                  <div className="relative">
                    <img
                      src={photo}
                      alt="Preview"
                      className="w-full h-48 object-cover rounded-lg"
                    />
                    <Button
                      type="button"
                      size="sm"
                      onClick={() => setPhoto('')}
                      className="absolute top-2 right-2 bg-catalog"
                    >
                      Alterar
                    </Button>
                  </div>
                ) : (
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    className="w-full h-48 border-2 border-dashed border-catalog/30 rounded-lg flex flex-col items-center justify-center gap-2 hover:border-catalog/50 transition-colors"
                  >
                    <Camera className="h-12 w-12 text-catalog" />
                    <span className="text-sm text-catalog">Tirar/Escolher Foto</span>
                  </button>
                )}
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  capture="environment"
                  onChange={handlePhotoCapture}
                  className="hidden"
                />
              </div>
            </div>

            {/* Name */}
            <div>
              <Label htmlFor="name" className="text-catalog">Nome do Item *</Label>
              <Input
                id="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Ex: Livros de cozinha"
                className="mt-2 border-catalog/30 focus:border-catalog"
                required
              />
            </div>

            {/* Weight */}
            <div>
              <Label htmlFor="weight" className="text-catalog">Peso (kg)</Label>
              <Input
                id="weight"
                type="number"
                step="0.1"
                value={weight}
                onChange={(e) => setWeight(e.target.value)}
                placeholder="0.0"
                className="mt-2 border-catalog/30 focus:border-catalog"
              />
            </div>

            {/* Notes */}
            <div>
              <Label htmlFor="notes" className="text-catalog">Notas</Label>
              <Textarea
                id="notes"
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Observações sobre o item..."
                className="mt-2 border-catalog/30 focus:border-catalog resize-none"
                rows={3}
              />
            </div>
          </div>

          <Button
            type="submit"
            className="w-full bg-catalog hover:bg-catalog/90 text-white shadow-smooth-md"
            size="lg"
          >
            <Plus className="mr-2 h-5 w-5" />
            Adicionar Item
          </Button>
        </form>
      </div>
    </div>
  );
};

export default Catalog;
