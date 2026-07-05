import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SensorService } from './services/sensor.service';
import { SensorReading } from './models/sensor-reading';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent implements OnInit {
  latest: SensorReading | null = null;
  history: SensorReading[] = [];
  error = '';

  constructor(private sensorService: SensorService) {}

  ngOnInit(): void {
    this.refresh();
    setInterval(() => this.refresh(), 5000);
  }

  refresh(): void {
    this.sensorService.getLatest().subscribe({
      next: (data) => {
        this.latest = data;
        this.error = '';
      },
      error: () => {
        this.error = 'Impossible de joindre l\'API Express.';
      },
    });

    this.sensorService.getHistory(20).subscribe({
      next: (data) => (this.history = data),
    });
  }
}
