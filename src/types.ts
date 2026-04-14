export interface Student {
  id: string;
  name: string;
  phone: string;
  city: string;
  country: string;
}

export interface User {
  username: string;
  role: 'admin' | 'student';
}
