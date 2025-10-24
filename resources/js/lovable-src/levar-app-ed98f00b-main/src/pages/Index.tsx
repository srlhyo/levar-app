import { useNavigate } from 'react-router-dom';
import { Camera, Heart, Package, FileText } from 'lucide-react';
import { useState } from 'react';
import { toast } from '@/hooks/use-toast';

const Index = () => {
  const navigate = useNavigate();
  const [fullModeActive, setFullModeActive] = useState(false);
  const [clickCount, setClickCount] = useState(0);

  const handleFooterClick = () => {
    const newCount = clickCount + 1;
    setClickCount(newCount);
    
    if (newCount === 3) {
      setFullModeActive(true);
      toast({
        title: "Modo completo ativado ✨",
        duration: 3000,
      });
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="p-6 text-center border-b">
        <h1 className="text-3xl font-bold text-foreground mb-2">
          Decidir o que Levar
        </h1>
        <p className="text-muted-foreground">
          Organize sua mudança de forma simples e visual
        </p>
      </div>

      {/* Mode Cards */}
      <div className="p-6 grid gap-4 max-w-2xl mx-auto">
        <button
          onClick={() => fullModeActive && navigate('/catalog')}
          disabled={!fullModeActive}
          className="bg-catalog-secondary hover:bg-catalog-accent transition-all duration-300 rounded-2xl p-6 text-left shadow-smooth-md hover:shadow-smooth-lg hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 disabled:hover:shadow-smooth-md"
        >
          <div className="flex items-center gap-4">
            <div className="bg-gradient-catalog p-4 rounded-xl shadow-smooth-sm">
              <Camera className="h-8 w-8 text-white" />
            </div>
            <div className="flex-1">
              <h2 className="text-xl font-bold text-catalog mb-1">Catalogar</h2>
              <p className="text-sm text-muted-foreground">Tire fotos e adicione itens</p>
            </div>
          </div>
        </button>

        <button
          onClick={() => navigate('/decide')}
          className="bg-decide-secondary hover:bg-decide-accent transition-all duration-300 rounded-2xl p-6 text-left shadow-smooth-md hover:shadow-smooth-lg hover:scale-[1.02] active:scale-[0.98]"
        >
          <div className="flex items-center gap-4">
            <div className="bg-gradient-decide p-4 rounded-xl shadow-smooth-sm">
              <Heart className="h-8 w-8 text-white" />
            </div>
            <div className="flex-1">
              <h2 className="text-xl font-bold text-decide mb-1">Decidir</h2>
              <p className="text-sm text-muted-foreground">Escolha o que levar</p>
            </div>
          </div>
        </button>

        <button
          onClick={() => fullModeActive && navigate('/pack')}
          disabled={!fullModeActive}
          className="bg-pack-secondary hover:bg-pack-accent transition-all duration-300 rounded-2xl p-6 text-left shadow-smooth-md hover:shadow-smooth-lg hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 disabled:hover:shadow-smooth-md"
        >
          <div className="flex items-center gap-4">
            <div className="bg-gradient-pack p-4 rounded-xl shadow-smooth-sm">
              <Package className="h-8 w-8 text-white" />
            </div>
            <div className="flex-1">
              <h2 className="text-xl font-bold text-pack mb-1">Embalar</h2>
              <p className="text-sm text-muted-foreground">Organize suas malas</p>
            </div>
          </div>
        </button>

        <button
          onClick={() => fullModeActive && navigate('/summary')}
          disabled={!fullModeActive}
          className="bg-summary-secondary hover:bg-summary-accent transition-all duration-300 rounded-2xl p-6 text-left shadow-smooth-md hover:shadow-smooth-lg hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 disabled:hover:shadow-smooth-md"
        >
          <div className="flex items-center gap-4">
            <div className="bg-gradient-summary p-4 rounded-xl shadow-smooth-sm">
              <FileText className="h-8 w-8 text-white" />
            </div>
            <div className="flex-1">
              <h2 className="text-xl font-bold text-summary mb-1">Resumo</h2>
              <p className="text-sm text-muted-foreground">Veja o progresso</p>
            </div>
          </div>
        </button>
      </div>

      {/* Footer */}
      <div className="p-6 text-center text-sm text-muted-foreground">
        <p 
          onClick={handleFooterClick}
          className="cursor-pointer select-none"
        >
          UK → Brasil • 2 malas de 23kg cada
        </p>
      </div>
    </div>
  );
};

export default Index;
