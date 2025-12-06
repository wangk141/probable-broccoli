import { Component, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-sidebar',
  standalone: false,
  templateUrl: './sidebar.component.html',
})
export class SidebarComponent {
  @Output() linkClicked = new EventEmitter<void>();

  onLinkClick() {
    this.linkClicked.emit();
  }
}