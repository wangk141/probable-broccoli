import { Component, OnInit, ViewChild, ElementRef, AfterViewChecked } from '@angular/core';

@Component({
  selector: 'app-logs',
  standalone: false,
  templateUrl: './logs.component.html',
})
export class LogsComponent implements OnInit, AfterViewChecked {
  @ViewChild('logContainer') private logContainer!: ElementRef;
  logs: string[] = [];
  private shouldScroll = true;

  ngOnInit() {
    setInterval(() => {
      const now = new Date().toLocaleTimeString();
      this.logs.push(`[${now}] Event: random log #${this.logs.length + 1}`);
      if (this.logs.length > 200) {
        this.logs.shift();
      }
    }, 2000);
  }

  ngAfterViewChecked() {
    if (this.shouldScroll) {
      this.scrollToBottom();
    }
  }

  private scrollToBottom(): void {
    try {
      this.logContainer.nativeElement.scrollTop = this.logContainer.nativeElement.scrollHeight;
    } catch(err) { }
  }

  onScroll(): void {
    const element = this.logContainer.nativeElement;
    const atBottom = element.scrollHeight - element.scrollTop <= element.clientHeight + 50;
    this.shouldScroll = atBottom;
  }
}