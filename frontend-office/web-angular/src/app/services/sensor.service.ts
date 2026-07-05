import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { SensorReading } from '../models/sensor-reading';

const API_BASE = 'http://localhost:3000/api';

@Injectable({ providedIn: 'root' })
export class SensorService {
  constructor(private http: HttpClient) {}

  getLatest(deviceId?: string): Observable<SensorReading> {
    const params = deviceId ? `?deviceId=${deviceId}` : '';
    return this.http.get<SensorReading>(`${API_BASE}/sensors/latest${params}`);
  }

  getHistory(limit = 50): Observable<SensorReading[]> {
    return this.http.get<SensorReading[]>(`${API_BASE}/sensors/history?limit=${limit}`);
  }
}
