import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CrudOp } from "./crud-op/crud-op";
// import { CrudImpl } from "./crud-impl/crud-impl";

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CrudOp],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('mds-demo');
}
