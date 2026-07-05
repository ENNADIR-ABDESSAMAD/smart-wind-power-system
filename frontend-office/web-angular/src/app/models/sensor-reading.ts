export interface SensorReading {
  id: number;
  device_id: string;
  voltage: number;
  temperature: number | null;
  humidity: number | null;
  relay_on: boolean;
  recorded_at: string;
}
