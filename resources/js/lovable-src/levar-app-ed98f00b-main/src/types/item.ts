export type Decision = 'keep' | 'discard' | 'later' | 'pending';
export type Luggage = 'A' | 'B' | null;

export interface Item {
  id: string;
  name: string;
  photo?: string;
  notes?: string;
  weight: number;
  decision: Decision;
  packed: boolean;
  luggage: Luggage;
  createdAt: string;
}
