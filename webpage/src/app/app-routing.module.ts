import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TicketsComponent } from './pages/tickets/tickets.component';
import { KnowledgebaseComponent } from './pages/knowledgebase/knowledgebase.component';
import { LogsComponent } from './pages/logs/logs.component';

const routes: Routes = [
  { path: '', redirectTo: 'tickets', pathMatch: 'full' },
  { path: 'tickets', component: TicketsComponent },
  { path: 'knowledgebase', component: KnowledgebaseComponent },
  { path: 'logs', component: LogsComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }