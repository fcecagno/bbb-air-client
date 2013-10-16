package 
{
	import flash.events.MouseEvent;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;
	import org.mconf.mobile.testing.ViewTests;
	import org.mconf.mobile.view.mic.api.IMicButton;
	import org.osflash.signals.utils.proceedOnSignal;
	

	public class ViewTests extends ViewTests
	{
		[After]
		override public function after(): void
		{
			super.after();
		}
		
		/**
		 * Tests that the MicButton implements ITemplateView.
		 */
		[Test]
		public function implements_expectedInterface(): void
		{
			assertThat(createView() as IMicButton, notNullValue());
		}
		
		/**
		 * By default the turnOnMicrofoneSignal should not be null.
		 */
		[Test]
		public function default_turnOnMicSignalIsNotNull(): void
		{
			assertThat(createView().turnOnMicSignal, notNullValue());
		}
		
		/**
		 * By default the turnOffMicrofoneSignal should not be null.
		 */
		[Test]
		public function default_turnOffMicSignalIsNotNull(): void
		{
			assertThat(createView().turnOffMicSignal, notNullValue());
		}
		
		/**
		 * By default the MicButton should not be enabled.
		 */
		[Test]
		public function default_micButtonShouldBeDisabled(): void
		{
			assertThat(createView().enabled, isFalse());
		}
		
		/**
		 * Tests that when the MicButton is clicked the turnOnMicSignal
		 * is dispatched.
		 */
		[Test(async)]
		public function clickCancelButton_DispatchesCancelSignal(): void
		{
			var micButton: MicButton = createView();
			proceedOnSignal(this, micButton.turnOnMicSignal);
			click(micButton);
		}
		
		/**
		 * Disposing of the view should remove all the listeners on the 
		 * turnOffMicSignal.
		 */
		[Test]
		public function dispose_RemovesListenersToTurnOffMicSignal(): void
		{
			var micButton: MicButton = createView();
			micButton.turnOffMicSignal.add(dummyMethod);
			micButton.dispose();
			
			assertThat(micButton.turnOffMicSignal.numListeners, equalTo(0));
		}	
		
		/**
		 * Disposing of the view should remove all the listeners on the 
		 * turnOnMicSignal.
		 */
		[Test]
		public function dispose_RemovesListenersToTurnOnMicSignal(): void
		{
			var micButton: MicButton = createView();
			micButton.turnOnMicSignal.add(dummyMethod);
			micButton.dispose();
			
			assertThat(micButton.turnOnMicSignal.numListeners, equalTo(0));
		}	
		
		/**
		 * Creates the test subject.
		 */
		private function createView(): MicButton
		{
			var micButton: MicButton = new MicButton();
			addToUI(micButton);
			return micButton;
		}
	}
}