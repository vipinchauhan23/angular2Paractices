
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'text-editor',
  template: `
  `,
  // directives: [FroalaEditorDirective, FroalaViewDirective],
  providers: [],
  styleUrls: []
})

export class TextEditorComponent implements OnInit {

  public editorContent: any;
  titleOptions: any;

  constructor() {
    this.initializeFloraEditor();
  }

  ngOnInit() {
    this.editorContent = '<p>This is my awesome content</p>';
  }

  private initializeFloraEditor() {
    this.editorContent = '<p>This is my awesome content</p>';
    this.titleOptions = {
      placeholderText: 'Edit Your Content Here!',
      charCounterCount: false
    };
  }
}
