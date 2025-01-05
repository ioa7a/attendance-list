import { getAuth, signInWithEmailAndPassword } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js'; // 'firebase/auth'

export class AuthenticationManager {
    auth = getAuth();
    signIn(email, password) {
        signInWithEmailAndPassword(this.auth, email, password)
            .then((_) => {
                alert("Active user: " + email);
                location.href = 'MainView.html';
            })
            .catch((error) => {
                const errorCode = error.code;
                const errorMessage = error.message;
                alert("ERROR: " + errorCode + " " + errorMessage);
            });
    }

    signOut() {
        this.auth.signOut().then(() => {
            console.log('Signed Out');
            location.href = 'SignInView.html'
        })
    }
}