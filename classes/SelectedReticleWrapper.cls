public class SelectedReticleWrapper{
        public Reticle__c eachSelectedreticlewrapper{get;set;}
        public Boolean IsChecked {get;set;} 
        public boolean isInserted{get;set;}      


        public SelectedReticleWrapper(Reticle__c eachReticle) {
            eachSelectedreticlewrapper  = eachreticle;
            IsChecked                   = false;
            isInserted                  = false;
        }
        public SelectedReticleWrapper(Reticle__c eachReticle,Boolean isChecked) {
            this.eachSelectedreticlewrapper  = eachreticle;
            this.IsChecked                   = isChecked  ;
            this.isInserted                  = false;
        }
    }