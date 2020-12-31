import { Directive, ElementRef, Input, OnChanges, Renderer2, SimpleChanges, SimpleChange } from '@angular/core';

@Directive({
  selector: '[appButtonSpinner]'
})
export class ButtonSpinnerDirective implements OnChanges {
  @Input('appButtonSpinner') active: boolean | undefined = false;

  private originalWidth = 0;
  private originalText = '';

  constructor(private el: ElementRef, private renderer: Renderer2) {}

  public ngOnChanges(changes: SimpleChanges): void {
    if (this.shouldSpinnerBeActivated(changes.active)) {
      this.originalWidth = this.el.nativeElement.getBoundingClientRect().width;
      this.originalText = this.el.nativeElement.textContent;
      this.setSpinnerAndWidth(this.originalWidth);
    } else if (this.shouldSpinnerBeDeactivated(changes.active)) {
      this.backToPreviousState(this.originalText);
    }
  }

  private shouldSpinnerBeActivated(active: SimpleChange): boolean {
    return active && active.currentValue === true;
  }

  private shouldSpinnerBeDeactivated(active: SimpleChange): boolean {
    return active.currentValue === false && active.previousValue === true;
  }

  private setSpinnerAndWidth(width: number): void {
    this.renderer.addClass(this.el.nativeElement, 'button-spinner');
    this.renderer.setProperty(this.el.nativeElement, 'textContent', '');
    this.renderer.setStyle(this.el.nativeElement, 'min-width', this.originalWidth + 'px');
  }

  private backToPreviousState(text: string): void {
    this.renderer.removeClass(this.el.nativeElement, 'button-spinner');
    this.renderer.setProperty(this.el.nativeElement, 'textContent', text);
    this.renderer.removeStyle(this.el.nativeElement, 'min-width');  // might be problematic if this is already set
  }
}
