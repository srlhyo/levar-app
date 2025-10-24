import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Package, CheckCircle2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { storage } from '@/lib/storage';
import { Item } from '@/types/item';
import { toast } from 'sonner';

const Pack = () => {
  const navigate = useNavigate();
  const [items, setItems] = useState<Item[]>([]);
  const MAX_WEIGHT = 23;

  useEffect(() => {
    loadItems();
  }, []);

  const loadItems = () => {
    const allItems = storage.getItems();
    const keepItems = allItems.filter(item => item.decision === 'keep');
    setItems(keepItems);
  };

  const togglePacked = (id: string) => {
    const item = items.find(i => i.id === id);
    if (!item) return;

    storage.updateItem(id, { packed: !item.packed });
    toast.success(item.packed ? 'Item desmarcado' : 'Item embalado!');
    loadItems();
  };

  const assignLuggage = (id: string, luggage: 'A' | 'B') => {
    storage.updateItem(id, { luggage, packed: true });
    toast.success(`Atribuído à mala ${luggage}`);
    loadItems();
  };

  const getWeightByLuggage = (luggage: 'A' | 'B') => {
    return items
      .filter(item => item.luggage === luggage)
      .reduce((sum, item) => sum + item.weight, 0);
  };

  const weightA = getWeightByLuggage('A');
  const weightB = getWeightByLuggage('B');
  const unassigned = items.filter(item => !item.luggage);
  const packed = items.filter(item => item.packed);

  return (
    <div className="min-h-screen bg-pack-secondary">
      <div className="bg-gradient-pack text-white p-6 shadow-smooth-md">
        <div className="flex items-center gap-4 mb-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => navigate('/')}
            className="text-white hover:bg-white/20"
          >
            <ArrowLeft className="h-6 w-6" />
          </Button>
          <h1 className="text-2xl font-bold">Embalar</h1>
        </div>
        <p className="text-white/90 text-sm">
          {packed.length} de {items.length} itens embalados
        </p>
      </div>

      <div className="p-6 space-y-6">
        {/* Weight Status */}
        <div className="grid grid-cols-2 gap-4">
          <div className="bg-card rounded-xl p-4 shadow-smooth-sm">
            <div className="text-sm text-muted-foreground mb-1">Mala A</div>
            <div className="text-2xl font-bold text-pack">
              {weightA.toFixed(1)}kg
            </div>
            <div className="text-xs text-muted-foreground">
              de {MAX_WEIGHT}kg
            </div>
            <div className="mt-2 h-2 bg-pack/20 rounded-full overflow-hidden">
              <div
                className="h-full bg-pack transition-all"
                style={{ width: `${Math.min(100, (weightA / MAX_WEIGHT) * 100)}%` }}
              />
            </div>
          </div>

          <div className="bg-card rounded-xl p-4 shadow-smooth-sm">
            <div className="text-sm text-muted-foreground mb-1">Mala B</div>
            <div className="text-2xl font-bold text-pack">
              {weightB.toFixed(1)}kg
            </div>
            <div className="text-xs text-muted-foreground">
              de {MAX_WEIGHT}kg
            </div>
            <div className="mt-2 h-2 bg-pack/20 rounded-full overflow-hidden">
              <div
                className="h-full bg-pack transition-all"
                style={{ width: `${Math.min(100, (weightB / MAX_WEIGHT) * 100)}%` }}
              />
            </div>
          </div>
        </div>

        {/* Items List */}
        {unassigned.length === 0 && items.length > 0 ? (
          <div className="text-center py-12 space-y-4">
            <div className="text-6xl">✅</div>
            <h2 className="text-2xl font-bold text-pack">Tudo embalado!</h2>
            <p className="text-muted-foreground">
              Todos os itens foram atribuídos às malas
            </p>
          </div>
        ) : unassigned.length === 0 ? (
          <div className="text-center py-12 space-y-4">
            <Package className="h-16 w-16 text-muted-foreground mx-auto" />
            <h2 className="text-xl font-semibold text-muted-foreground">
              Nenhum item para embalar
            </h2>
            <p className="text-sm text-muted-foreground">
              Primeiro catalogue e decida quais itens levar
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {unassigned.map(item => (
              <div
                key={item.id}
                className="bg-card rounded-xl p-4 shadow-smooth-sm"
              >
                <div className="flex items-start gap-3">
                  {item.photo && (
                    <img
                      src={item.photo}
                      alt={item.name}
                      className="w-16 h-16 rounded-lg object-cover"
                    />
                  )}
                  <div className="flex-1 min-w-0">
                    <h3 className="font-semibold text-foreground">
                      {item.name}
                    </h3>
                    <p className="text-sm text-muted-foreground">
                      {item.weight}kg
                    </p>
                  </div>
                </div>

                <div className="flex gap-2 mt-4">
                  <Button
                    onClick={() => assignLuggage(item.id, 'A')}
                    className="flex-1 bg-pack hover:bg-pack/90"
                    size="sm"
                  >
                    Mala A
                  </Button>
                  <Button
                    onClick={() => assignLuggage(item.id, 'B')}
                    className="flex-1 bg-pack hover:bg-pack/90"
                    size="sm"
                  >
                    Mala B
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default Pack;
