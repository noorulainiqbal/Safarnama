#!/bin/bash
echo "DEPLOYING FIRESTORE RULES..."
firebase deploy --only firestore:rules
echo "Deployment command sent. Check output above for success/failure."
