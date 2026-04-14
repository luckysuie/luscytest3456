/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import { useState, FormEvent } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  User as UserIcon, 
  Lock, 
  Eye, 
  EyeOff, 
  ArrowRight, 
  GraduationCap,
  CheckCircle2,
  BookOpen,
  LogOut,
  Search,
  MapPin,
  Phone,
  Hash,
  Globe
} from 'lucide-react';

// Import mock database and types
import studentsData from '../database/students.json';
import { Student, User } from './types';

export default function App() {
  const [studentId, setStudentId] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [error, setError] = useState('');

  const handleLogin = async (e: FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    // Default credentials check
    if (studentId === 'studentadmin' && password === 'admin123') {
      setCurrentUser({ username: 'studentadmin', role: 'admin' });
    } else {
      setError('Invalid credentials. Use studentadmin / admin123');
    }
    
    setIsLoading(false);
  };

  const handleLogout = () => {
    setCurrentUser(null);
    setStudentId('');
    setPassword('');
  };

  return (
    <div className="min-h-screen bg-[#f0f4f8] flex items-center justify-center p-4 font-sans selection:bg-blue-100 selection:text-blue-700">
      {/* Background Decorative Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-[10%] -left-[10%] w-[40%] h-[40%] rounded-full bg-blue-50/50 blur-3xl" />
        <div className="absolute -bottom-[10%] -right-[10%] w-[40%] h-[40%] rounded-full bg-indigo-50/50 blur-3xl" />
      </div>

      <AnimatePresence mode="wait">
        {!currentUser ? (
          <motion.div 
            key="login-view"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.5, ease: "easeOut" }}
            className="w-full max-w-md relative"
          >
            <div className="bg-white rounded-3xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 p-8 md:p-10">
              {/* Header */}
              <div className="mb-10 text-center">
                <motion.div 
                  initial={{ scale: 0.8 }}
                  animate={{ scale: 1 }}
                  className="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-blue-600 text-white mb-6 shadow-lg shadow-blue-200"
                >
                  <GraduationCap size={28} />
                </motion.div>
                <h1 className="text-2xl font-bold text-slate-900 tracking-tight">Student Portal</h1>
                <p className="text-slate-500 mt-2 text-sm">Sign in to access your dashboard</p>
              </div>

              <form onSubmit={handleLogin} className="space-y-5">
                {/* Student ID Field */}
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-slate-700 ml-1" htmlFor="studentId">
                    Username
                  </label>
                  <div className="relative group">
                    <div className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors">
                      <UserIcon size={18} />
                    </div>
                    <input
                      id="studentId"
                      type="text"
                      required
                      value={studentId}
                      onChange={(e) => setStudentId(e.target.value)}
                      placeholder="studentadmin"
                      className="w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all placeholder:text-slate-400 text-slate-900"
                    />
                  </div>
                </div>

                {/* Password Field */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between ml-1">
                    <label className="text-sm font-semibold text-slate-700" htmlFor="password">
                      Password
                    </label>
                  </div>
                  <div className="relative group">
                    <div className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors">
                      <Lock size={18} />
                    </div>
                    <input
                      id="password"
                      type={showPassword ? "text" : "password"}
                      required
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      placeholder="admin123"
                      className="w-full pl-11 pr-12 py-3.5 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all placeholder:text-slate-400 text-slate-900"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"
                    >
                      {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                    </button>
                  </div>
                </div>

                {error && (
                  <motion.p 
                    initial={{ opacity: 0, x: -10 }}
                    animate={{ opacity: 1, x: 0 }}
                    className="text-red-500 text-xs font-medium ml-1"
                  >
                    {error}
                  </motion.p>
                )}

                {/* Submit Button */}
                <button
                  type="submit"
                  disabled={isLoading}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-100 transition-all active:scale-[0.98] disabled:opacity-70 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                >
                  {isLoading ? (
                    <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  ) : (
                    <>
                      <span>Sign In</span>
                      <ArrowRight size={18} />
                    </>
                  )}
                </button>

                <div className="pt-4 flex items-center justify-center space-x-2 text-slate-400">
                  <BookOpen size={14} />
                  <span className="text-xs uppercase tracking-widest font-medium">Academic Portal v2.0</span>
                </div>
              </form>
            </div>
          </motion.div>
        ) : (
          <motion.div 
            key="dashboard-view"
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
            className="w-full max-w-5xl relative"
          >
            <div className="bg-white rounded-3xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 overflow-hidden">
              {/* Dashboard Header */}
              <div className="bg-slate-900 p-6 md:p-8 text-white flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 rounded-xl bg-blue-500 flex items-center justify-center shadow-lg shadow-blue-500/20">
                    <GraduationCap size={24} />
                  </div>
                  <div>
                    <h2 className="text-xl font-bold">Student Administration</h2>
                    <p className="text-slate-400 text-sm">Welcome back, {currentUser.username}</p>
                  </div>
                </div>
                <button 
                  onClick={handleLogout}
                  className="flex items-center justify-center space-x-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg transition-colors text-sm font-semibold"
                >
                  <LogOut size={16} />
                  <span>Logout</span>
                </button>
              </div>

              {/* Dashboard Content */}
              <div className="p-6 md:p-8">
                <div className="flex flex-col md:flex-row md:items-center justify-between mb-8 gap-4">
                  <div>
                    <h3 className="text-lg font-bold text-slate-900">Student Records</h3>
                    <p className="text-slate-500 text-sm">Managing {studentsData.length} total students</p>
                  </div>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={16} />
                    <input 
                      type="text" 
                      placeholder="Search students..." 
                      className="pl-10 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all w-full md:w-64"
                    />
                  </div>
                </div>

                {/* Student Table */}
                <div className="overflow-x-auto">
                  <table className="w-full text-left border-collapse">
                    <thead>
                      <tr className="border-b border-slate-100">
                        <th className="pb-4 font-semibold text-slate-400 text-xs uppercase tracking-wider pl-2">
                          <div className="flex items-center space-x-1">
                            <Hash size={12} />
                            <span>ID</span>
                          </div>
                        </th>
                        <th className="pb-4 font-semibold text-slate-400 text-xs uppercase tracking-wider">
                          <div className="flex items-center space-x-1">
                            <UserIcon size={12} />
                            <span>Name</span>
                          </div>
                        </th>
                        <th className="pb-4 font-semibold text-slate-400 text-xs uppercase tracking-wider">
                          <div className="flex items-center space-x-1">
                            <Phone size={12} />
                            <span>Phone</span>
                          </div>
                        </th>
                        <th className="pb-4 font-semibold text-slate-400 text-xs uppercase tracking-wider">
                          <div className="flex items-center space-x-1">
                            <MapPin size={12} />
                            <span>City</span>
                          </div>
                        </th>
                        <th className="pb-4 font-semibold text-slate-400 text-xs uppercase tracking-wider pr-2">
                          <div className="flex items-center space-x-1">
                            <Globe size={12} />
                            <span>Country</span>
                          </div>
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-50">
                      {(studentsData as Student[]).map((student) => (
                        <motion.tr 
                          key={student.id}
                          initial={{ opacity: 0 }}
                          animate={{ opacity: 1 }}
                          className="group hover:bg-slate-50/50 transition-colors"
                        >
                          <td className="py-4 pl-2">
                            <span className="text-xs font-mono font-medium text-slate-400 bg-slate-100 px-2 py-1 rounded">
                              {student.id}
                            </span>
                          </td>
                          <td className="py-4">
                            <span className="font-semibold text-slate-900">{student.name}</span>
                          </td>
                          <td className="py-4 text-slate-600 text-sm">
                            {student.phone}
                          </td>
                          <td className="py-4 text-slate-600 text-sm">
                            {student.city}
                          </td>
                          <td className="py-4 text-slate-600 text-sm pr-2">
                            {student.country}
                          </td>
                        </motion.tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}



