import { useState } from 'react';
import { Item } from '@/types/item';
import { Package } from 'lucide-react';

interface SwipeCardProps {
  item: Item;
  onSwipe: (decision: 'keep' | 'discard' | 'later') => void;
}

const SwipeCard = ({ item, onSwipe }: SwipeCardProps) => {
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState(false);
  const [startPos, setStartPos] = useState({ x: 0, y: 0 });

  const handleStart = (clientX: number, clientY: number) => {
    setIsDragging(true);
    setStartPos({ x: clientX - position.x, y: clientY - position.y });
  };

  const handleMove = (clientX: number, clientY: number) => {
    if (!isDragging) return;
    const newX = clientX - startPos.x;
    setPosition({ x: newX, y: 0 });
  };

  const handleEnd = () => {
    setIsDragging(false);
    
    const threshold = 100;
    if (position.x > threshold) {
      onSwipe('keep');
    } else if (position.x < -threshold) {
      onSwipe('discard');
    }
    
    setPosition({ x: 0, y: 0 });
  };

  const rotation = position.x / 10;
  const opacity = Math.max(0.3, 1 - Math.abs(position.x) / 200);

  return (
    <div
      className="relative w-full max-w-sm cursor-grab active:cursor-grabbing select-none"
      style={{
        transform: `translateX(${position.x}px) rotate(${rotation}deg)`,
        transition: isDragging ? 'none' : 'transform 0.3s ease-out',
        opacity,
      }}
      onMouseDown={(e) => handleStart(e.clientX, e.clientY)}
      onMouseMove={(e) => handleMove(e.clientX, e.clientY)}
      onMouseUp={handleEnd}
      onMouseLeave={handleEnd}
      onTouchStart={(e) => handleStart(e.touches[0].clientX, e.touches[0].clientY)}
      onTouchMove={(e) => handleMove(e.touches[0].clientX, e.touches[0].clientY)}
      onTouchEnd={handleEnd}
    >
      <div className="bg-card rounded-2xl shadow-smooth-lg overflow-hidden">
        {item.photo ? (
          <img
            src={item.photo}
            alt={item.name}
            className="w-full h-80 object-cover"
          />
        ) : (
          <div className="w-full h-80 bg-gradient-to-br from-decide-accent to-decide-secondary flex items-center justify-center">
            <Package className="h-24 w-24 text-decide/30" />
          </div>
        )}
        
        <div className="p-6">
          <h3 className="text-2xl font-bold text-foreground mb-2">{item.name}</h3>
          
          {item.weight > 0 && (
            <p className="text-sm text-muted-foreground mb-2">
              Peso: {item.weight} kg
            </p>
          )}
          
          {item.notes && (
            <p className="text-sm text-muted-foreground">
              {item.notes}
            </p>
          )}
        </div>
      </div>

      {/* Swipe indicators */}
      {position.x > 50 && (
        <div className="absolute top-8 right-8 bg-decide text-white px-6 py-3 rounded-full text-lg font-bold rotate-12">
          LEVAR
        </div>
      )}
      {position.x < -50 && (
        <div className="absolute top-8 left-8 bg-destructive text-white px-6 py-3 rounded-full text-lg font-bold -rotate-12">
          NÃO
        </div>
      )}
    </div>
  );
};

export default SwipeCard;
