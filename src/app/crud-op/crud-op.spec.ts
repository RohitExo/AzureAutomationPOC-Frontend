import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrudOp } from './crud-op';

describe('CrudOp', () => {
  let component: CrudOp;
  let fixture: ComponentFixture<CrudOp>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CrudOp]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CrudOp);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
