import { Component, ElementRef, inject, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { HttpClient } from '@angular/common/http';
import { NgIf } from '@angular/common';
import { FormGroup, FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { Employee, EmployeeService } from './employee.service';

@Component({
  selector: 'app-crud-op',
  standalone: true,
  imports: [
    NgIf,
    ReactiveFormsModule,
    MatTableModule,
  ],
  templateUrl: './crud-op.html',
  styleUrl: './crud-op.scss',
})
export class CrudOp implements OnInit {

  public showForm = false;
  dataSource = new MatTableDataSource<Employee>();

  private employeeToUpdate: Employee | null = null;

  dataCols = [
  { name: 'employeeId', headerTitle: 'Employee ID' },
  { name: 'designation', headerTitle: 'Designation' },
  { name: 'salary', headerTitle: 'Salary' },
  { name: 'experience', headerTitle: 'Experience' },
  { name: 'action', headerTitle: 'Action' },
];
  displayCols = ['employeeId', 'designation', 'salary', 'experience', 'action'];

  employeeForm!: FormGroup;

  constructor(private employeeService: EmployeeService) { }

  ngOnInit(): void {
    this.getAllEmployee();
    this.employeeForm = new FormGroup({
      employeeId: new FormControl('', [Validators.required]),
      designation: new FormControl('', Validators.required),
      salary: new FormControl('', [Validators.required]),
      experience: new FormControl('', [Validators.required]),
    });
  }

  get employeeId() {
    return this.employeeForm.get('employeeId');
  }

  get designation() {
    return this.employeeForm.get('designation');
  }

  get salary() {
    return this.employeeForm.get('salary');
  }

  get experience() {
    return this.employeeForm.get('experience');
  }
  @ViewChild('empModal') empModal: ElementRef | undefined;
  employeeList: Employee[] = [];

  http = inject(HttpClient);

  FormOpen(): void {
    this.showForm = true;
    if (this.empModal) {
      this.empModal.nativeElement.style.display = 'block';
    }
  }
  fullResetForm(): void {
    this.employeeForm.reset();
    this.employeeToUpdate = null;
  }
  FormClose(): void {
    if (this.empModal) {
      this.empModal.nativeElement.style.display = 'none';
    }
  }

  getAllEmployee() {
    // this.http.get("https://app-emp-backend-001.azurewebsites.net/api/EmployeeMaster").subscribe((res: any) => {
    //   this.employeeList = res;
    //   this.dataSource.data = this.employeeList;
    // })
    this.employeeService.getEmployees().subscribe((res: any) => {
      this.employeeList = res;
      this.dataSource.data = this.employeeList;
    });
  }

  onSubmit(): void {
    if (this.employeeForm.valid) {
      if (this.employeeToUpdate) {
        const updatedEmployee = this.employeeForm.value;
        const currentData = this.dataSource.data;
        const updatedData = currentData.map(emp =>
          emp.employeeId === this.employeeToUpdate!.employeeId ? updatedEmployee : emp
        );
        this.dataSource.data = updatedData;
        alert('Employee Updated!');
      } else {
        const newEmployee: Employee = this.employeeForm.value;
        const currentData = this.dataSource.data;
        this.employeeService.addEmployee(newEmployee).subscribe();
        this.dataSource.data = [...currentData, newEmployee];
        alert('New Employee Added!');
      }
      this.FormClose();
    } else {
      this.employeeForm.markAllAsTouched();
      console.error('Form is invalid.');
    }
  }

  onUpdate(employee: Employee): void {
    this.employeeToUpdate = employee;
    this.employeeForm.patchValue(employee);
    this.showForm = true;
  }

  onDelete(employee: Employee): void {
    const confirmDelete = confirm(`Are you sure you want to delete employee with ID: ${employee.employeeId}?`);
    if (confirmDelete) {
      const currentData = this.dataSource.data;
      this.dataSource.data = currentData.filter(emp => emp.employeeId !== employee.employeeId);
      alert('Employee Deleted!');
    }
  }
}
