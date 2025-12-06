import { Component } from '@angular/core';

@Component({
  selector: 'app-knowledgebase',
  standalone: false,
  templateUrl: './knowledgebase.component.html',
})
export class KnowledgebaseComponent {
  content: string = '';
  savedMessage: string = '';

  save() {
    this.savedMessage = 'Saved';
    setTimeout(() => this.savedMessage = '', 2000);
  }
}
