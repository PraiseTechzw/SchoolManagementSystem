// ChikoroPro App JavaScript

// DOM Elements
const loginBtn = document.getElementById('loginBtn');
const loginForm = document.getElementById('loginForm');
const loginFormBtn = document.getElementById('loginFormBtn');
const roleSelect = document.getElementById('role');
const adminDashboard = document.getElementById('adminDashboard');
const clerkDashboard = document.getElementById('clerkDashboard');
const teacherDashboard = document.getElementById('teacherDashboard');
const parentDashboard = document.getElementById('parentDashboard');
const studentDashboard = document.getElementById('studentDashboard');
const appContent = document.getElementById('appContent');

// App State
const appState = {
    isLoggedIn: false,
    currentUser: null,
    role: null,
    isOnline: navigator.onLine,
    firebaseConfig: {
        apiKey: getFirebaseConfig('apiKey'),
        projectId: getFirebaseConfig('projectId'),
        appId: getFirebaseConfig('appId')
    }
};

// Function to get Firebase config from environment variables
function getFirebaseConfig(key) {
    // In a real app, these would come from environment variables
    // For the demo, we'll check if they've been provided via form
    const configs = {
        apiKey: localStorage.getItem('FIREBASE_API_KEY') || 'demo-api-key',
        projectId: localStorage.getItem('FIREBASE_PROJECT_ID') || 'demo-project-id',
        appId: localStorage.getItem('FIREBASE_APP_ID') || 'demo-app-id'
    };
    
    return configs[key];
}

// Initialize the app
function initApp() {
    // Check if Firebase config is available (real values, not demo ones)
    if (
        appState.firebaseConfig.apiKey === 'demo-api-key' || 
        appState.firebaseConfig.projectId === 'demo-project-id' || 
        appState.firebaseConfig.appId === 'demo-app-id'
    ) {
        showFirebaseConfigPrompt();
    }
    
    // Listen to online/offline events
    window.addEventListener('online', updateOnlineStatus);
    window.addEventListener('offline', updateOnlineStatus);
    
    // Set up event listeners
    loginBtn.addEventListener('click', toggleLoginForm);
    loginFormBtn.addEventListener('click', handleLogin);
    
    // Add click listeners for all dashboard menu items
    document.querySelectorAll('.sidebar-menu li').forEach(item => {
        item.addEventListener('click', function() {
            // Deselect all menu items
            document.querySelectorAll('.sidebar-menu li').forEach(menuItem => {
                menuItem.classList.remove('active');
            });
            // Select the clicked menu item
            this.classList.add('active');
        });
    });
    
    // Check if user is already logged in from local storage
    const savedUser = localStorage.getItem('currentUser');
    if (savedUser) {
        try {
            appState.currentUser = JSON.parse(savedUser);
            appState.isLoggedIn = true;
            appState.role = localStorage.getItem('userRole') || 'student';
            showDashboard(appState.role);
        } catch (error) {
            console.error('Error parsing saved user:', error);
            localStorage.removeItem('currentUser');
            localStorage.removeItem('userRole');
        }
    }
}

// Toggle login form visibility
function toggleLoginForm() {
    if (appState.isLoggedIn) {
        // If logged in, log out
        handleLogout();
    } else {
        // Show login form
        hideAllDashboards();
        loginForm.classList.remove('hidden');
    }
}

// Handle login form submission
function handleLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const role = roleSelect.value;
    
    if (!email || !password) {
        alert('Please enter both email and password');
        return;
    }
    
    // In a real app, this would authenticate with Firebase
    // For demo, we'll simulate login success
    simulateLogin(email, role);
}

// Simulate successful login
function simulateLogin(email, role) {
    // Create a mock user object
    const user = {
        email,
        displayName: getDisplayName(role),
        uid: generateUid(),
        photoURL: null,
        emailVerified: true
    };
    
    // Update app state
    appState.isLoggedIn = true;
    appState.currentUser = user;
    appState.role = role;
    
    // Save to local storage for persistence
    localStorage.setItem('currentUser', JSON.stringify(user));
    localStorage.setItem('userRole', role);
    
    // Update UI
    updateLoginButton();
    showDashboard(role);
}

// Handle logout
function handleLogout() {
    // In a real app, this would sign out from Firebase
    // For demo, we'll just clear the state
    appState.isLoggedIn = false;
    appState.currentUser = null;
    appState.role = null;
    
    // Clear local storage
    localStorage.removeItem('currentUser');
    localStorage.removeItem('userRole');
    
    // Update UI
    updateLoginButton();
    hideAllDashboards();
    loginForm.classList.remove('hidden');
}

// Update login button text based on login state
function updateLoginButton() {
    loginBtn.textContent = appState.isLoggedIn ? 'Logout' : 'Login';
}

// Show the appropriate dashboard based on role
function showDashboard(role) {
    hideAllDashboards();
    
    switch(role) {
        case 'admin':
            adminDashboard.classList.remove('hidden');
            break;
        case 'clerk':
            clerkDashboard.classList.remove('hidden');
            break;
        case 'teacher':
            teacherDashboard.classList.remove('hidden');
            break;
        case 'parent':
            parentDashboard.classList.remove('hidden');
            break;
        case 'student':
            studentDashboard.classList.remove('hidden');
            break;
        default:
            loginForm.classList.remove('hidden');
    }
}

// Hide all dashboards
function hideAllDashboards() {
    loginForm.classList.add('hidden');
    adminDashboard.classList.add('hidden');
    clerkDashboard.classList.add('hidden');
    teacherDashboard.classList.add('hidden');
    parentDashboard.classList.add('hidden');
    studentDashboard.classList.add('hidden');
}

// Update online/offline status
function updateOnlineStatus() {
    appState.isOnline = navigator.onLine;
    
    // Update all connectivity status indicators
    document.querySelectorAll('.connectivity-status').forEach(indicator => {
        if (appState.isOnline) {
            indicator.classList.remove('offline');
            indicator.classList.add('online');
            indicator.innerHTML = '<span class="material-icons">cloud_done</span><span>Online</span>';
        } else {
            indicator.classList.remove('online');
            indicator.classList.add('offline');
            indicator.innerHTML = '<span class="material-icons">cloud_off</span><span>Offline</span>';
        }
    });
}

// Show Firebase configuration prompt
function showFirebaseConfigPrompt() {
    const configPrompt = document.createElement('div');
    configPrompt.className = 'firebase-config-prompt';
    configPrompt.innerHTML = `
        <div class="firebase-config-modal">
            <h2>Firebase Configuration Required</h2>
            <p>Enter your Firebase project details to connect to your database.</p>
            <div class="form-group">
                <label for="apiKey">API Key</label>
                <input type="text" id="apiKey" placeholder="Firebase API Key">
            </div>
            <div class="form-group">
                <label for="projectId">Project ID</label>
                <input type="text" id="projectId" placeholder="Firebase Project ID">
            </div>
            <div class="form-group">
                <label for="appId">App ID</label>
                <input type="text" id="appId" placeholder="Firebase App ID">
            </div>
            <button id="saveFirebaseConfig" class="button primary">Save Configuration</button>
            <button id="skipFirebaseConfig" class="button secondary">Skip for Demo</button>
        </div>
    `;
    
    document.body.appendChild(configPrompt);
    
    // Add styles for the prompt
    const style = document.createElement('style');
    style.textContent = `
        .firebase-config-prompt {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .firebase-config-modal {
            background-color: white;
            padding: 2rem;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }
        
        .firebase-config-modal h2 {
            margin-bottom: 0.5rem;
            color: var(--primary-color);
        }
        
        .firebase-config-modal p {
            margin-bottom: 1.5rem;
            color: var(--text-secondary);
        }
        
        .firebase-config-modal .button {
            margin-top: 1rem;
        }
        
        .firebase-config-modal .secondary {
            margin-left: 0.5rem;
        }
    `;
    document.head.appendChild(style);
    
    // Add event listeners
    document.getElementById('saveFirebaseConfig').addEventListener('click', function() {
        const apiKey = document.getElementById('apiKey').value;
        const projectId = document.getElementById('projectId').value;
        const appId = document.getElementById('appId').value;
        
        if (apiKey && projectId && appId) {
            localStorage.setItem('FIREBASE_API_KEY', apiKey);
            localStorage.setItem('FIREBASE_PROJECT_ID', projectId);
            localStorage.setItem('FIREBASE_APP_ID', appId);
            
            // Update app state
            appState.firebaseConfig.apiKey = apiKey;
            appState.firebaseConfig.projectId = projectId;
            appState.firebaseConfig.appId = appId;
            
            // Remove the prompt
            document.body.removeChild(configPrompt);
        } else {
            alert('Please fill in all Firebase configuration fields');
        }
    });
    
    document.getElementById('skipFirebaseConfig').addEventListener('click', function() {
        document.body.removeChild(configPrompt);
    });
}

// Helper function to get display name based on role
function getDisplayName(role) {
    const names = {
        admin: 'John Administrator',
        clerk: 'Sarah Clerk',
        teacher: 'Robert Moyo',
        parent: 'Grace Parent',
        student: 'Tafadzwa Student'
    };
    
    return names[role] || 'User';
}

// Generate a random UID
function generateUid() {
    return 'user_' + Math.random().toString(36).substring(2, 15);
}

// Initialize the app when the DOM is loaded
document.addEventListener('DOMContentLoaded', initApp);