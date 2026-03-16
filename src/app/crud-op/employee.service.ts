import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";

export interface Employee{
    employeeId: number;
    designation:string;
    salary:number;
    experience:number;
}

@Injectable({ providedIn: 'root' })
export class EmployeeService {

  private apiUrl = 'https://app-emp-backend-001.azurewebsites.net/api/EmployeeMaster';

  constructor(private https: HttpClient) { }

  getEmployees(): Observable<Employee[]> {
    return this.https.get<Employee[]>(this.apiUrl);
  }

  addEmployee(employee: Employee): Observable<Employee> {
    return this.https.post<Employee>(this.apiUrl, employee);
  }

  updateEmployee(employee: any): Observable<any> {
    return this.https.put(`${this.apiUrl}/${employee.employeeId}`, employee);
  }

  deleteEmployee(id: number): Observable<any> {
    return this.https.delete(`${this.apiUrl}/${id}`);
  }
}