import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Download, FileText } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { storage } from '@/lib/storage';
import { Item } from '@/types/item';
import { toast } from 'sonner';

const Summary = () => {
  const navigate = useNavigate();
  const [items, setItems] = useState<Item[]>([]);

  useEffect(() => {
    setItems(storage.getItems());
  }, []);

  const stats = {
    total: items.length,
    pending: items.filter(i => i.decision === 'pending').length,
    keep: items.filter(i => i.decision === 'keep').length,
    discard: items.filter(i => i.decision === 'discard').length,
    later: items.filter(i => i.decision === 'later').length,
    packed: items.filter(i => i.packed).length,
    luggageA: items.filter(i => i.luggage === 'A').length,
    luggageB: items.filter(i => i.luggage === 'B').length,
    weightA: items.filter(i => i.luggage === 'A').reduce((s, i) => s + i.weight, 0),
    weightB: items.filter(i => i.luggage === 'B').reduce((s, i) => s + i.weight, 0),
  };

  const exportCSV = () => {
    const keepItems = items.filter(i => i.decision === 'keep');
    
    const csv = [
      ['Nome', 'Peso (kg)', 'Mala', 'Embalado', 'Notas'].join(','),
      ...keepItems.map(item => [
        item.name,
        item.weight,
        item.luggage || 'Não atribuída',
        item.packed ? 'Sim' : 'Não',
        item.notes || ''
      ].join(','))
    ].join('\n');

    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `mudanca-${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    toast.success('CSV exportado!');
  };

  return (
    <div className="min-h-screen bg-summary-secondary">
      <div className="bg-gradient-summary text-white p-6 shadow-smooth-md">
        <div className="flex items-center gap-4 mb-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => navigate('/')}
            className="text-white hover:bg-white/20"
          >
            <ArrowLeft className="h-6 w-6" />
          </Button>
          <h1 className="text-2xl font-bold">Resumo</h1>
        </div>
        <p className="text-white/90 text-sm">Visão geral da sua mudança</p>
      </div>

      <div className="p-6 space-y-6">
        {/* Progress Overview */}
        <div className="bg-card rounded-xl p-6 shadow-smooth-sm">
          <h2 className="text-lg font-semibold mb-4">Progresso</h2>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <div className="text-3xl font-bold text-summary">{stats.total}</div>
              <div className="text-sm text-muted-foreground">Total de itens</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-catalog">{stats.pending}</div>
              <div className="text-sm text-muted-foreground">Por decidir</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-decide">{stats.keep}</div>
              <div className="text-sm text-muted-foreground">Vai levar</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-pack">{stats.packed}</div>
              <div className="text-sm text-muted-foreground">Embalados</div>
            </div>
          </div>
        </div>

        {/* Luggage Info */}
        <div className="bg-card rounded-xl p-6 shadow-smooth-sm">
          <h2 className="text-lg font-semibold mb-4">Malas</h2>
          <div className="space-y-4">
            <div className="flex justify-between items-center p-4 bg-pack-secondary rounded-lg">
              <div>
                <div className="font-semibold">Mala A</div>
                <div className="text-sm text-muted-foreground">
                  {stats.luggageA} itens
                </div>
              </div>
              <div className="text-right">
                <div className="text-2xl font-bold text-pack">
                  {stats.weightA.toFixed(1)}kg
                </div>
                <div className="text-xs text-muted-foreground">de 23kg</div>
              </div>
            </div>

            <div className="flex justify-between items-center p-4 bg-pack-secondary rounded-lg">
              <div>
                <div className="font-semibold">Mala B</div>
                <div className="text-sm text-muted-foreground">
                  {stats.luggageB} itens
                </div>
              </div>
              <div className="text-right">
                <div className="text-2xl font-bold text-pack">
                  {stats.weightB.toFixed(1)}kg
                </div>
                <div className="text-xs text-muted-foreground">de 23kg</div>
              </div>
            </div>
          </div>
        </div>

        {/* Export */}
        <div className="space-y-3">
          <Button
            onClick={exportCSV}
            className="w-full bg-summary hover:bg-summary/90"
            size="lg"
            disabled={stats.keep === 0}
          >
            <Download className="mr-2 h-5 w-5" />
            Exportar CSV
          </Button>

          {stats.keep === 0 && (
            <p className="text-center text-sm text-muted-foreground">
              Primeiro decida quais itens levar para poder exportar
            </p>
          )}
        </div>

        {/* Items List */}
        {stats.keep > 0 && (
          <div className="bg-card rounded-xl p-6 shadow-smooth-sm">
            <h2 className="text-lg font-semibold mb-4">Itens a levar</h2>
            <div className="space-y-3">
              {items
                .filter(i => i.decision === 'keep')
                .map(item => (
                  <div
                    key={item.id}
                    className="flex items-center gap-3 p-3 bg-background rounded-lg"
                  >
                    {item.photo && (
                      <img
                        src={item.photo}
                        alt={item.name}
                        className="w-12 h-12 rounded object-cover"
                      />
                    )}
                    <div className="flex-1 min-w-0">
                      <div className="font-medium">{item.name}</div>
                      <div className="text-sm text-muted-foreground">
                        {item.weight}kg
                        {item.luggage && ` • Mala ${item.luggage}`}
                        {item.packed && ' • ✓'}
                      </div>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Summary;
