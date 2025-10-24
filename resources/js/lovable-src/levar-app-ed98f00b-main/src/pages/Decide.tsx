import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Heart, X, Clock } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { storage } from '@/lib/storage';
import { Item } from '@/types/item';
import SwipeCard from '@/components/SwipeCard';
import { toast } from 'sonner';

const Decide = () => {
  const navigate = useNavigate();
  const [items, setItems] = useState<Item[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    const allItems = storage.getItems();
    const pendingItems = allItems.filter(item => item.decision === 'pending');
    setItems(pendingItems);
  }, []);

  const handleDecision = (decision: 'keep' | 'discard' | 'later') => {
    if (currentIndex >= items.length) return;

    const currentItem = items[currentIndex];
    storage.updateItem(currentItem.id, { decision });

    const messages = {
      keep: '✓ Vai na mala!',
      discard: '✗ Não vai',
      later: '⏰ Decidir depois'
    };

    toast.success(messages[decision]);
    setCurrentIndex(prev => prev + 1);
  };

  const currentItem = items[currentIndex];
  const progress = items.length > 0 ? ((currentIndex / items.length) * 100) : 100;

  return (
    <div className="min-h-screen bg-decide-secondary flex flex-col">
      <div className="bg-gradient-decide text-white p-6 shadow-smooth-md">
        <div className="flex items-center gap-4 mb-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => navigate('/')}
            className="text-white hover:bg-white/20"
          >
            <ArrowLeft className="h-6 w-6" />
          </Button>
          <h1 className="text-2xl font-bold">Decidir</h1>
        </div>
        <p className="text-white/90 text-sm mb-4">
          {items.length > 0 
            ? `${currentIndex + 1} de ${items.length} itens`
            : 'Nenhum item para decidir'}
        </p>
        <div className="h-2 bg-white/20 rounded-full overflow-hidden">
          <div 
            className="h-full bg-white transition-all duration-300"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center p-6">
        {currentItem ? (
          <>
            <SwipeCard
              item={currentItem}
              onSwipe={handleDecision}
            />

            <div className="flex gap-4 mt-8">
              <Button
                onClick={() => handleDecision('discard')}
                size="lg"
                variant="outline"
                className="rounded-full w-16 h-16 border-2 border-destructive text-destructive hover:bg-destructive hover:text-white"
              >
                <X className="h-8 w-8" />
              </Button>
              
              <Button
                onClick={() => handleDecision('later')}
                size="lg"
                variant="outline"
                className="rounded-full w-16 h-16 border-2 border-summary text-summary hover:bg-summary hover:text-white"
              >
                <Clock className="h-8 w-8" />
              </Button>
              
              <Button
                onClick={() => handleDecision('keep')}
                size="lg"
                className="rounded-full w-16 h-16 bg-decide hover:bg-decide/90"
              >
                <Heart className="h-8 w-8" />
              </Button>
            </div>
          </>
        ) : (
          <div className="text-center space-y-4">
            <div className="text-6xl">🎉</div>
            <h2 className="text-2xl font-bold text-decide">Tudo decidido!</h2>
            <p className="text-muted-foreground">
              Você já decidiu sobre todos os itens catalogados
            </p>
            <Button onClick={() => navigate('/')} className="bg-decide">
              Voltar ao Início
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default Decide;
