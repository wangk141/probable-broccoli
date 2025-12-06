import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { TicketsComponent } from './pages/tickets/tickets.component';
import { KnowledgebaseComponent } from './pages/knowledgebase/knowledgebase.component';
import { LogsComponent } from './pages/logs/logs.component';

@NgModule({
  declarations: [
    AppComponent,
    SidebarComponent,
    TicketsComponent,
    KnowledgebaseComponent,
    LogsComponent
  ],
  imports: [
    BrowserModule,
    CommonModule,
    FormsModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }