public interface Subscriber<T> {
    
    public void onNext(T data);
    public void onError();
    public void onComplete();

}
