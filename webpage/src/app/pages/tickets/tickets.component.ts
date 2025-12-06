// tickets.component.ts
import { Component } from '@angular/core';

const FILTERS = ['All', 'Open', 'In Progress', 'Closed'] as const;
type Filter = (typeof FILTERS)[number];

@Component({
  selector: 'app-tickets',
  standalone: false,
  templateUrl: './tickets.component.html',
})
export class TicketsComponent {
  readonly FILTERS = FILTERS;
  filter: Filter = 'All';

  tickets = [
    { id: 1, subject: 'Login issue', status: 'Open', createdAt: '2025-12-01' },
    { id: 2, subject: 'Page not loading', status: 'In Progress', createdAt: '2025-12-02' },
    { id: 3, subject: 'Feature request', status: 'Closed', createdAt: '2025-12-03' },
    { id: 4, subject: 'Bug in checkout', status: 'Open', createdAt: '2025-12-04' },
    { id: 5, subject: 'UI glitch', status: 'In Progress', createdAt: '2025-12-05' },
    { id: 6, subject: 'Performance issue', status: 'Closed', createdAt: '2025-12-06' },
  ];

  get filteredTickets() {
    return this.filter === 'All'
      ? this.tickets
      : this.tickets.filter(t => t.status === this.filter);
  }
}
